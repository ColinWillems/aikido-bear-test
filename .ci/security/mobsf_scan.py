#!/usr/bin/env python3
"""MobSF static scan driver: upload -> scan -> download reports -> gate.

Configured entirely through environment variables so no endpoint or token is
ever hardcoded:

    MOBSF_URL       base URL of the MobSF server (e.g. https://mobsf.internal)
    MOBSF_API_KEY   REST API key (read from env only; never logged)

Given a built artifact (.apk / .aab / .ipa), it uploads the file, runs the
static scan, writes the JSON and PDF reports into --out-dir, and applies the
MobSF gate from policy_config.json for the selected mode.

Stdlib only (urllib). Exit codes: 0 pass, 1 gate failure, 2 config/IO/HTTP error.
"""

from __future__ import annotations

import argparse
import json
import mimetypes
import os
import sys
import urllib.error
import urllib.parse
import urllib.request
import uuid

API_UPLOAD = "/api/v1/upload"
API_SCAN = "/api/v1/scan"
API_REPORT_JSON = "/api/v1/report_json"
API_REPORT_PDF = "/api/v1/download_pdf"


class MobSFError(Exception):
    """Configuration, IO or HTTP failure (exit code 2)."""


# --------------------------------------------------------------------------- #
# HTTP helpers (stdlib multipart / form encoding)
# --------------------------------------------------------------------------- #
def _multipart(fields: dict[str, str], file_field: str, file_path: str):
    boundary = f"----bear{uuid.uuid4().hex}"
    crlf = b"\r\n"
    body = bytearray()
    for name, value in fields.items():
        body += (f"--{boundary}").encode() + crlf
        body += (f'Content-Disposition: form-data; name="{name}"').encode() + crlf + crlf
        body += value.encode() + crlf
    filename = os.path.basename(file_path)
    ctype = mimetypes.guess_type(filename)[0] or "application/octet-stream"
    with open(file_path, "rb") as fh:
        content = fh.read()
    body += (f"--{boundary}").encode() + crlf
    body += (f'Content-Disposition: form-data; name="{file_field}"; '
             f'filename="{filename}"').encode() + crlf
    body += (f"Content-Type: {ctype}").encode() + crlf + crlf
    body += content + crlf
    body += (f"--{boundary}--").encode() + crlf
    return bytes(body), f"multipart/form-data; boundary={boundary}"


def _post(url: str, api_key: str, data: bytes, content_type: str, timeout: int) -> bytes:
    req = urllib.request.Request(url, data=data, method="POST")
    req.add_header("Authorization", api_key)
    req.add_header("Content-Type", content_type)
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:  # noqa: S310 (internal host)
            return resp.read()
    except urllib.error.HTTPError as exc:
        raise MobSFError(f"HTTP {exc.code} from {urllib.parse.urlparse(url).path}") from exc
    except (urllib.error.URLError, OSError) as exc:
        raise MobSFError(f"request to {urllib.parse.urlparse(url).path} failed: {exc}") from exc


def _post_form(base: str, path: str, api_key: str, form: dict, timeout: int) -> bytes:
    data = urllib.parse.urlencode(form).encode()
    return _post(base.rstrip("/") + path, api_key,
                 data, "application/x-www-form-urlencoded", timeout)


# --------------------------------------------------------------------------- #
# MobSF flow
# --------------------------------------------------------------------------- #
def upload(base: str, api_key: str, file_path: str, timeout: int) -> str:
    if not os.path.isfile(file_path):
        raise MobSFError(f"artifact not found: {file_path}")
    body, ctype = _multipart({}, "file", file_path)
    raw = _post(base.rstrip("/") + API_UPLOAD, api_key, body, ctype, timeout)
    try:
        return json.loads(raw)["hash"]
    except (json.JSONDecodeError, KeyError) as exc:
        raise MobSFError(f"unexpected upload response: {exc}") from exc


def scan(base: str, api_key: str, file_hash: str, timeout: int) -> dict:
    raw = _post_form(base, API_SCAN, api_key, {"hash": file_hash}, timeout)
    try:
        return json.loads(raw)
    except json.JSONDecodeError as exc:
        raise MobSFError(f"scan response was not JSON: {exc}") from exc


def download_pdf(base: str, api_key: str, file_hash: str, out_path: str, timeout: int) -> None:
    raw = _post_form(base, API_REPORT_PDF, api_key, {"hash": file_hash}, timeout)
    with open(out_path, "wb") as fh:
        fh.write(raw)


def parse_appsec_counts(report: dict) -> dict[str, int]:
    """Best-effort extraction of high/critical finding counts across MobSF
    report shapes (the 'appsec' block on modern MobSF, falling back to
    severities inside 'code_analysis'/'findings')."""
    counts = {"critical": 0, "high": 0, "warning": 0}
    appsec = report.get("appsec")
    if isinstance(appsec, dict):
        counts["high"] = len(appsec.get("high", []) or [])
        counts["warning"] = len(appsec.get("warning", []) or [])
        counts["critical"] = len(appsec.get("critical", []) or [])
        return counts

    ca = report.get("code_analysis")
    findings = {}
    if isinstance(ca, dict):
        findings = ca.get("findings", ca)
    if isinstance(findings, dict):
        for meta in findings.values():
            sev = ""
            if isinstance(meta, dict):
                sev = str(meta.get("metadata", {}).get("severity")
                          or meta.get("severity") or "").lower()
            if sev in ("critical",):
                counts["critical"] += 1
            elif sev in ("high", "error"):
                counts["high"] += 1
            elif sev in ("warning",):
                counts["warning"] += 1
    return counts


def evaluate_gate(counts: dict[str, int], mode_cfg: dict) -> list[str]:
    failures = []
    max_high = mode_cfg.get("max_high", 0)
    max_crit = mode_cfg.get("max_critical", 0)
    if counts.get("critical", 0) > max_crit:
        failures.append(f"critical findings {counts['critical']} > allowed {max_crit}")
    if counts.get("high", 0) > max_high:
        failures.append(f"high findings {counts['high']} > allowed {max_high}")
    return failures


def main(argv=None) -> int:
    here = os.path.dirname(os.path.abspath(__file__))
    p = argparse.ArgumentParser(description="MobSF upload/scan/report/gate")
    p.add_argument("--file", required=True, help="path to .apk/.aab/.ipa")
    p.add_argument("--mode", choices=["main", "release"], default="main")
    p.add_argument("--out-dir", default="mobsf-reports")
    p.add_argument("--config", default=os.path.join(here, "policy_config.json"))
    p.add_argument("--timeout", type=int, default=900)
    args = p.parse_args(argv)

    base = os.environ.get("MOBSF_URL")
    api_key = os.environ.get("MOBSF_API_KEY")
    if not base or not api_key:
        print("ERROR: MOBSF_URL and MOBSF_API_KEY must both be set.", file=sys.stderr)
        return 2

    try:
        with open(args.config, "r", encoding="utf-8") as fh:
            config = json.load(fh)
        mode_cfg = config.get("mobsf", {}).get("modes", {}).get(args.mode)
        if mode_cfg is None:
            raise MobSFError(f"mobsf.modes.{args.mode} missing from {args.config}")
        os.makedirs(args.out_dir, exist_ok=True)

        print(f"Uploading {os.path.basename(args.file)} to MobSF ...")
        file_hash = upload(base, api_key, args.file, args.timeout)
        print("Running static scan (this can take a few minutes) ...")
        report = scan(base, api_key, file_hash, args.timeout)

        json_path = os.path.join(args.out_dir, f"{os.path.basename(args.file)}.mobsf.json")
        pdf_path = os.path.join(args.out_dir, f"{os.path.basename(args.file)}.mobsf.pdf")
        with open(json_path, "w", encoding="utf-8") as fh:
            json.dump(report, fh, indent=2)
        try:
            download_pdf(base, api_key, file_hash, pdf_path, args.timeout)
        except MobSFError as exc:
            print(f"WARNING: PDF download failed: {exc}", file=sys.stderr)
        counts = parse_appsec_counts(report)
        failures = evaluate_gate(counts, mode_cfg)
    except MobSFError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2

    print(f"== MobSF gate ({args.mode}) ==")
    print(f"reports: {json_path}")
    print(f"findings: critical={counts['critical']} high={counts['high']} "
          f"warning={counts['warning']}")
    if failures:
        for f in failures:
            print(f"  BLOCK: {f}")
        print(f"\nFAIL: MobSF gate failed for mode '{args.mode}'.")
        return 1
    print(f"\nPASS: MobSF gate satisfied for mode '{args.mode}'.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
