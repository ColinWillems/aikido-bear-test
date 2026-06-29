#!/usr/bin/env python3
"""Software-composition-analysis gate for Trivy JSON output.

Reads a Trivy `--format json` report (filesystem or image scan), applies the
severity policy from policy_config.json for the selected mode, honours an
optional vulnerability baseline/allowlist, prints a concise per-severity
summary and fails (exit 1) only when a blocking vulnerability is present.

Stdlib only. Exit codes: 0 pass, 1 blocking vuln, 2 bad/missing input.
"""

from __future__ import annotations

import argparse
import json
import os
import sys

SEVERITIES = ["CRITICAL", "HIGH", "MEDIUM", "LOW", "UNKNOWN"]


class GateError(Exception):
    """Missing or malformed input (exit code 2)."""


def _load_json(path: str) -> dict:
    if not os.path.isfile(path):
        raise GateError(f"file not found: {path}")
    try:
        with open(path, "r", encoding="utf-8") as fh:
            return json.load(fh)
    except (json.JSONDecodeError, OSError) as exc:
        raise GateError(f"could not parse {path}: {exc}") from exc


def extract_vulnerabilities(trivy_report: dict) -> list[dict]:
    """Flatten Trivy results into a list of vulnerability dicts."""
    if not isinstance(trivy_report, dict) or "Results" not in trivy_report:
        raise GateError("not a Trivy JSON report (missing 'Results')")
    vulns: list[dict] = []
    for result in trivy_report.get("Results") or []:
        target = result.get("Target", "?")
        for v in result.get("Vulnerabilities") or []:
            vulns.append({
                "id": v.get("VulnerabilityID", "UNKNOWN"),
                "pkg": v.get("PkgName", "?"),
                "installed": v.get("InstalledVersion", ""),
                "fixed": v.get("FixedVersion", ""),
                "severity": (v.get("Severity") or "UNKNOWN").upper(),
                "target": target,
            })
    return vulns


def load_baseline(path: str | None) -> set[str]:
    if not path:
        return set()
    doc = _load_json(path)
    return {
        e["id"] for e in doc.get("vulnerabilities", []) or []
        if isinstance(e, dict) and e.get("id")
    }


def evaluate(vulns, mode_cfg, baseline_ids):
    block_sev = set(mode_cfg.get("block_severities", []))
    require_fix = mode_cfg.get("require_fix_available", False)
    blocking, reported = [], []
    for v in vulns:
        if v["id"] in baseline_ids:
            reported.append(v)
            continue
        sev_blocks = v["severity"] in block_sev
        fix_ok = (not require_fix) or bool(v["fixed"])
        if sev_blocks and fix_ok:
            blocking.append(v)
        else:
            reported.append(v)
    return blocking, reported


def severity_counts(vulns) -> dict[str, int]:
    counts = {s: 0 for s in SEVERITIES}
    for v in vulns:
        counts[v["severity"]] = counts.get(v["severity"], 0) + 1
    return counts


def main(argv=None) -> int:
    here = os.path.dirname(os.path.abspath(__file__))
    p = argparse.ArgumentParser(description="Trivy SCA policy gate")
    p.add_argument("--report", required=True, help="Trivy JSON report path")
    p.add_argument("--mode", choices=["pr", "main", "release"], default="pr")
    p.add_argument("--config", default=os.path.join(here, "policy_config.json"))
    p.add_argument("--baseline", default=None, help="optional vuln allowlist JSON")
    args = p.parse_args(argv)

    try:
        config = _load_json(args.config)
        mode_cfg = config.get("sca", {}).get("modes", {}).get(args.mode)
        if mode_cfg is None:
            raise GateError(f"sca.modes.{args.mode} missing from {args.config}")
        vulns = extract_vulnerabilities(_load_json(args.report))
        baseline = load_baseline(args.baseline)
        blocking, reported = evaluate(vulns, mode_cfg, baseline)
    except GateError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2

    counts = severity_counts(vulns)
    print(f"== SCA gate ({args.mode}) ==")
    print("severity totals: " + ", ".join(f"{s}={counts[s]}" for s in SEVERITIES))
    print(f"blocking: {len(blocking)} | reported: {len(reported)} "
          f"| baseline-allowlisted: {len(baseline)}")
    if blocking:
        print("\nBLOCKING vulnerabilities:")
        for v in blocking:
            fix = f"fixed in {v['fixed']}" if v["fixed"] else "no fix available"
            print(f"  [{v['severity']:<8}] {v['id']} {v['pkg']}@{v['installed']} "
                  f"({fix}) - {v['target']}")
        print(f"\nFAIL: {len(blocking)} blocking vulnerability(ies) for mode '{args.mode}'.")
        return 1
    print(f"\nPASS: no blocking vulnerabilities for mode '{args.mode}'.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
