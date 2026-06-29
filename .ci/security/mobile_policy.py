#!/usr/bin/env python3
"""Mobile release-configuration policy checker for the BEAR Adventure app.

Statically inspects the Android manifest / Gradle config and the iOS
Info.plist / entitlements for the mobile-specific security rules described in
SECURITY_PIPELINE.md, applies the finding policy (pr / main / release) defined
in policy_config.json, honours baseline.json and time-boxed exceptions.json,
and emits a concise summary plus optional SARIF / JSON reports.

Stdlib only - no third-party dependencies - so it runs identically on a
developer laptop and on a clean CI runner.

Exit codes:
    0  no blocking findings for the selected mode
    1  one or more blocking policy violations
    2  bad usage / missing or malformed input files
"""

from __future__ import annotations

import argparse
import datetime as _dt
import json
import os
import plistlib
import re
import sys
from dataclasses import dataclass, field
from typing import Optional

from defusedxml import ElementTree as ET
from defusedxml.common import DefusedXmlException

ANDROID_NS = "http://schemas.android.com/apk/res/android"
SEVERITY_ORDER = ["INFO", "LOW", "MEDIUM", "HIGH", "CRITICAL"]
_SARIF_LEVEL = {
    "CRITICAL": "error",
    "HIGH": "error",
    "MEDIUM": "warning",
    "LOW": "note",
    "INFO": "note",
}

# Android permissions that warrant explicit review when present in a release.
DANGEROUS_PERMISSIONS = {
    "android.permission.ACCESS_FINE_LOCATION",
    "android.permission.ACCESS_BACKGROUND_LOCATION",
    "android.permission.READ_CONTACTS",
    "android.permission.READ_SMS",
    "android.permission.RECEIVE_SMS",
    "android.permission.RECORD_AUDIO",
    "android.permission.READ_EXTERNAL_STORAGE",
    "android.permission.WRITE_EXTERNAL_STORAGE",
    "android.permission.READ_PHONE_STATE",
    "android.permission.REQUEST_INSTALL_PACKAGES",
}

MIN_SUPPORTED_MIN_SDK = 23
MIN_SUPPORTED_TARGET_SDK = 33


class PolicyError(Exception):
    """Raised for missing or malformed inputs (maps to exit code 2)."""


@dataclass
class Finding:
    id: str
    severity: str
    title: str
    detail: str
    location: str
    mobile_config: bool = True
    # populated by apply_policy
    status: str = "blocking"  # blocking | reported | suppressed
    suppress_reason: str = ""

    def sarif_level(self) -> str:
        return _SARIF_LEVEL.get(self.severity, "note")


@dataclass
class PolicyResult:
    findings: list[Finding] = field(default_factory=list)

    @property
    def blocking(self) -> list[Finding]:
        return [f for f in self.findings if f.status == "blocking"]

    @property
    def reported(self) -> list[Finding]:
        return [f for f in self.findings if f.status == "reported"]

    @property
    def suppressed(self) -> list[Finding]:
        return [f for f in self.findings if f.status == "suppressed"]


# --------------------------------------------------------------------------- #
# Input loading
# --------------------------------------------------------------------------- #
def load_json(path: str) -> dict:
    if not os.path.isfile(path):
        raise PolicyError(f"required file not found: {path}")
    try:
        with open(path, "r", encoding="utf-8") as fh:
            return json.load(fh)
    except (json.JSONDecodeError, OSError) as exc:
        raise PolicyError(f"could not parse JSON {path}: {exc}") from exc


def _strip_comment_keys(obj):
    if isinstance(obj, dict):
        return {k: _strip_comment_keys(v) for k, v in obj.items() if not k.startswith("$")}
    if isinstance(obj, list):
        return [_strip_comment_keys(v) for v in obj]
    return obj


def active_exception_ids(exceptions_doc: dict, today: Optional[_dt.date] = None) -> dict[str, str]:
    """Return {finding_id: reason} for non-expired, well-formed exceptions."""
    today = today or _dt.date.today()
    active: dict[str, str] = {}
    for entry in exceptions_doc.get("exceptions", []) or []:
        if not isinstance(entry, dict):
            continue
        fid = entry.get("id")
        expires = entry.get("expires")
        reason = entry.get("reason", "")
        owner = entry.get("owner", "")
        if not (fid and expires and reason and owner):
            # Incomplete exception is ignored on purpose so the finding keeps blocking.
            continue
        try:
            exp_date = _dt.date.fromisoformat(str(expires))
        except ValueError:
            continue
        if exp_date >= today:
            active[fid] = f"exception until {expires} ({owner}): {reason}"
    return active


def baseline_ids(baseline_doc: dict) -> set[str]:
    return {
        e["id"]
        for e in baseline_doc.get("findings", []) or []
        if isinstance(e, dict) and e.get("id")
    }


# --------------------------------------------------------------------------- #
# Android parsing / rules
# --------------------------------------------------------------------------- #
def _attr(elem, name: str) -> Optional[str]:
    return elem.get(f"{{{ANDROID_NS}}}{name}")


def _has_launcher_intent(component) -> bool:
    for intent in component.findall("intent-filter"):
        actions = {_attr(a, "name") for a in intent.findall("action")}
        cats = {_attr(c, "name") for c in intent.findall("category")}
        if "android.intent.action.MAIN" in actions and "android.intent.category.LAUNCHER" in cats:
            return True
    return False


def check_android_manifest(path: str) -> list[Finding]:
    findings: list[Finding] = []
    try:
        root = ET.parse(path).getroot()
    except (ET.ParseError, DefusedXmlException, OSError) as exc:
        raise PolicyError(f"could not parse AndroidManifest {path}: {exc}") from exc

    app = root.find("application")
    rel = os.path.relpath(path)
    if app is not None:
        if (_attr(app, "debuggable") or "").lower() == "true":
            findings.append(Finding(
                "ANDROID_DEBUGGABLE", "CRITICAL", "Debuggable application flag set",
                "android:debuggable=\"true\" in the manifest ships a debuggable app.", rel))
        if (_attr(app, "usesCleartextTraffic") or "").lower() == "true":
            findings.append(Finding(
                "ANDROID_CLEARTEXT_TRAFFIC", "HIGH", "Cleartext traffic permitted",
                "android:usesCleartextTraffic=\"true\" allows unencrypted HTTP.", rel))
        if (_attr(app, "allowBackup") or "").lower() == "true":
            findings.append(Finding(
                "ANDROID_BACKUP_ENABLED", "MEDIUM", "Application backup enabled",
                "android:allowBackup=\"true\" may expose app data via adb/cloud backup.", rel))
        nsc = _attr(app, "networkSecurityConfig")
        if nsc:
            findings.append(Finding(
                "ANDROID_NETWORK_SECURITY_CONFIG", "INFO", "Network Security Config present",
                f"networkSecurityConfig={nsc} - review for cleartext/trust-anchor overrides.",
                rel, mobile_config=False))

    # Exported components without a launcher/main intent.
    for tag in ("activity", "service", "receiver", "provider"):
        for comp in root.iter(tag):
            exported = (_attr(comp, "exported") or "").lower()
            name = _attr(comp, "name") or "<unnamed>"
            if exported == "true" and not _has_launcher_intent(comp):
                has_perm = _attr(comp, "permission") is not None
                sev = "MEDIUM" if has_perm else "HIGH"
                findings.append(Finding(
                    "ANDROID_EXPORTED_COMPONENT", sev,
                    f"Exported {tag} without launcher intent",
                    f"{tag} {name} is exported"
                    + (" (permission-guarded)" if has_perm else " and unguarded") + ".",
                    rel))

    # Dangerous permissions (reported, not release-blocking on their own).
    for perm in root.iter("uses-permission"):
        pname = _attr(perm, "name")
        if pname in DANGEROUS_PERMISSIONS:
            findings.append(Finding(
                "ANDROID_DANGEROUS_PERMISSION", "LOW", "Sensitive permission requested",
                f"Manifest requests {pname}; confirm it is required.", rel, mobile_config=False))

    # Non-standard deep-link schemes shipped in the production manifest. Only
    # look at BROWSABLE intent filters (real web/app deep links), not <queries>
    # visibility declarations or mailto/tel intents.
    seen_schemes: set[str] = set()
    for intent in root.iter("intent-filter"):
        cats = {_attr(c, "name") for c in intent.findall("category")}
        if "android.intent.category.BROWSABLE" not in cats:
            continue
        for data in intent.findall("data"):
            scheme = _attr(data, "scheme")
            if scheme and scheme not in ("http", "https") and scheme not in seen_schemes:
                seen_schemes.add(scheme)
                findings.append(Finding(
                    "ANDROID_CUSTOM_SCHEME_DEEPLINK", "LOW",
                    "Custom URL scheme deep link in manifest",
                    f"Custom scheme '{scheme}://' is registered; custom schemes are hijackable.",
                    rel, mobile_config=False))
    return findings


def check_android_gradle(path: str) -> list[Finding]:
    findings: list[Finding] = []
    if not os.path.isfile(path):
        raise PolicyError(f"required file not found: {path}")
    try:
        with open(path, "r", encoding="utf-8") as fh:
            text = fh.read()
    except OSError as exc:
        raise PolicyError(f"could not read {path}: {exc}") from exc
    rel = os.path.relpath(path)

    if not re.search(r"minifyEnabled\s+true", text):
        findings.append(Finding(
            "ANDROID_RELEASE_NO_MINIFY", "MEDIUM", "Release build is not minified",
            "No 'minifyEnabled true' found; R8 code shrinking/obfuscation is disabled.", rel))
    if re.search(r"release\s*\{[^}]*debuggable\s+true", text, re.S):
        findings.append(Finding(
            "ANDROID_RELEASE_DEBUGGABLE", "CRITICAL", "Release build type is debuggable",
            "The release buildType sets debuggable true.", rel))
    if re.search(r"signingConfig\s+signingConfigs\.debug", text):
        findings.append(Finding(
            "ANDROID_DEBUG_SIGNING", "HIGH", "Release signed with debug config",
            "A buildType references signingConfigs.debug.", rel))

    m = re.search(r"minSdkVersion\D+(\d+)", text)
    if m and int(m.group(1)) < MIN_SUPPORTED_MIN_SDK:
        findings.append(Finding(
            "ANDROID_OBSOLETE_MIN_SDK", "MEDIUM", "Obsolete minSdkVersion",
            f"minSdkVersion {m.group(1)} is below the supported floor "
            f"({MIN_SUPPORTED_MIN_SDK}).", rel))
    m = re.search(r"targetSdkVersion\D+(\d+)", text)
    if m and int(m.group(1)) < MIN_SUPPORTED_TARGET_SDK:
        findings.append(Finding(
            "ANDROID_OBSOLETE_TARGET_SDK", "MEDIUM", "Obsolete targetSdkVersion",
            f"targetSdkVersion {m.group(1)} is below the supported floor "
            f"({MIN_SUPPORTED_TARGET_SDK}).", rel))
    return findings


# --------------------------------------------------------------------------- #
# iOS parsing / rules
# --------------------------------------------------------------------------- #
def _load_plist(path: str) -> dict:
    if not os.path.isfile(path):
        raise PolicyError(f"required file not found: {path}")
    try:
        with open(path, "rb") as fh:
            return plistlib.load(fh)
    except (plistlib.InvalidFileException, OSError, ValueError) as exc:
        raise PolicyError(f"could not parse plist {path}: {exc}") from exc


def check_ios_info_plist(path: str) -> list[Finding]:
    findings: list[Finding] = []
    plist = _load_plist(path)
    rel = os.path.relpath(path)

    ats = plist.get("NSAppTransportSecurity", {})
    if isinstance(ats, dict):
        if ats.get("NSAllowsArbitraryLoads") is True:
            findings.append(Finding(
                "IOS_ATS_ARBITRARY_LOADS", "HIGH", "Broad App Transport Security exception",
                "NSAppTransportSecurity.NSAllowsArbitraryLoads=true disables ATS app-wide.", rel))
        if ats.get("NSAllowsArbitraryLoadsInWebContent") is True:
            findings.append(Finding(
                "IOS_ATS_ARBITRARY_LOADS_WEB", "MEDIUM", "ATS disabled for web content",
                "NSAllowsArbitraryLoadsInWebContent=true disables ATS in WebViews.", rel))
        for domain, cfg in (ats.get("NSExceptionDomains", {}) or {}).items():
            if isinstance(cfg, dict) and cfg.get("NSExceptionAllowsInsecureHTTPLoads") is True:
                findings.append(Finding(
                    "IOS_ATS_EXCEPTION_DOMAIN", "MEDIUM", "Per-domain insecure HTTP exception",
                    f"ATS exception domain '{domain}' allows insecure HTTP loads.", rel))

    for url_type in plist.get("CFBundleURLTypes", []) or []:
        for scheme in (url_type.get("CFBundleURLSchemes", []) if isinstance(url_type, dict) else []):
            findings.append(Finding(
                "IOS_CUSTOM_URL_SCHEME", "LOW", "Custom URL scheme registered",
                f"App registers custom URL scheme '{scheme}://' (hijackable).",
                rel, mobile_config=False))
    return findings


def check_ios_entitlements(path: str) -> list[Finding]:
    findings: list[Finding] = []
    plist = _load_plist(path)
    rel = os.path.relpath(path)

    aps = plist.get("aps-environment")
    if aps == "development":
        findings.append(Finding(
            "IOS_APS_ENV_DEVELOPMENT", "HIGH", "Development APS environment in entitlements",
            "aps-environment=development indicates a non-production push entitlement.", rel))
    if plist.get("get-task-allow") is True:
        findings.append(Finding(
            "IOS_DEBUG_ENTITLEMENT", "CRITICAL", "Debug entitlement get-task-allow enabled",
            "get-task-allow=true permits debugger attach; must be false in release.", rel))
    return findings


# --------------------------------------------------------------------------- #
# Collection + policy
# --------------------------------------------------------------------------- #
def collect_findings(app_dir: str) -> list[Finding]:
    targets = {
        "android_manifest": os.path.join(
            app_dir, "android", "app", "src", "main", "AndroidManifest.xml"),
        "android_gradle": os.path.join(app_dir, "android", "app", "build.gradle"),
        "ios_info": os.path.join(app_dir, "ios", "Runner", "Info.plist"),
        "ios_entitlements": os.path.join(app_dir, "ios", "Runner", "Runner.entitlements"),
    }
    missing = [p for p in targets.values() if not os.path.exists(p)]
    if len(missing) == len(targets):
        raise PolicyError(
            f"no mobile config files found under {app_dir!r}; is --app-dir correct?")

    findings: list[Finding] = []
    findings += check_android_manifest(targets["android_manifest"])
    findings += check_android_gradle(targets["android_gradle"])
    findings += check_ios_info_plist(targets["ios_info"])
    findings += check_ios_entitlements(targets["ios_entitlements"])
    return findings


def apply_policy(findings, mode_cfg, base_ids, exc_ids) -> PolicyResult:
    block_sev = set(mode_cfg.get("block_severities", []))
    honor_baseline = mode_cfg.get("honor_baseline", True)
    block_mobile_config = mode_cfg.get("block_mobile_config", False)

    for f in findings:
        if f.id in exc_ids:
            f.status, f.suppress_reason = "suppressed", exc_ids[f.id]
            continue
        if honor_baseline and f.id in base_ids:
            f.status, f.suppress_reason = "reported", "baselined"
            continue
        is_block = f.severity in block_sev or (block_mobile_config and f.mobile_config)
        f.status = "blocking" if is_block else "reported"
    return PolicyResult(findings)


# --------------------------------------------------------------------------- #
# Reporting
# --------------------------------------------------------------------------- #
def to_sarif(findings) -> dict:
    rules, results = {}, []
    for f in findings:
        rules.setdefault(f.id, {
            "id": f.id,
            "name": f.id.title().replace("_", ""),
            "shortDescription": {"text": f.title},
            "defaultConfiguration": {"level": f.sarif_level()},
            "properties": {"security-severity": {
                "CRITICAL": "9.5", "HIGH": "8.0", "MEDIUM": "5.0",
                "LOW": "3.0", "INFO": "1.0"}[f.severity]},
        })
        result = {
            "ruleId": f.id,
            "level": f.sarif_level(),
            "message": {"text": f"{f.title}: {f.detail}"},
            "locations": [{"physicalLocation": {
                "artifactLocation": {"uri": f.location.replace(os.sep, "/")}}}],
        }
        if f.status in ("reported", "suppressed"):
            result["suppressions"] = [{
                "kind": "external",
                "justification": f.suppress_reason or f.status,
            }]
        results.append(result)
    return {
        "$schema": "https://json.schemastore.org/sarif-2.1.0.json",
        "version": "2.1.0",
        "runs": [{
            "tool": {"driver": {
                "name": "bear-mobile-policy",
                "informationUri": "https://github.com/bearsnacks/bear-adventure",
                "rules": list(rules.values()),
            }},
            "results": results,
        }],
    }


def _print_summary(result: PolicyResult, mode: str) -> None:
    def line(f: Finding) -> str:
        return f"  [{f.severity:<8}] {f.id} - {f.title} ({f.location})"

    print(f"== Mobile config policy ({mode}) ==")
    print(f"findings: {len(result.findings)} | blocking: {len(result.blocking)} "
          f"| reported: {len(result.reported)} | suppressed: {len(result.suppressed)}")
    if result.blocking:
        print("\nBLOCKING:")
        for f in sorted(result.blocking,
                        key=lambda x: -SEVERITY_ORDER.index(x.severity)):
            print(line(f))
            print(f"      -> {f.detail}")
    if result.reported:
        print("\nreported (not blocking):")
        for f in result.reported:
            print(line(f) + (f"  [{f.suppress_reason}]" if f.suppress_reason else ""))
    if result.suppressed:
        print("\nsuppressed by exception:")
        for f in result.suppressed:
            print(line(f) + f"  [{f.suppress_reason}]")


def main(argv=None) -> int:
    here = os.path.dirname(os.path.abspath(__file__))
    parser = argparse.ArgumentParser(description="BEAR Adventure mobile config policy gate")
    parser.add_argument("--mode", choices=["pr", "main", "release"], default="pr")
    parser.add_argument("--app-dir", default=None,
                        help="Flutter app dir (default: from policy_config.json)")
    parser.add_argument("--config", default=os.path.join(here, "policy_config.json"))
    parser.add_argument("--baseline", default=os.path.join(here, "baseline.json"))
    parser.add_argument("--exceptions", default=os.path.join(here, "exceptions.json"))
    parser.add_argument("--sarif", default=None, help="write a SARIF report to this path")
    parser.add_argument("--json", dest="json_out", default=None,
                        help="write a JSON report to this path")
    args = parser.parse_args(argv)

    try:
        config = _strip_comment_keys(load_json(args.config))
        base = baseline_ids(load_json(args.baseline))
        exc = active_exception_ids(load_json(args.exceptions))
        mode_cfg = config.get("modes", {}).get(args.mode)
        if mode_cfg is None:
            raise PolicyError(f"mode '{args.mode}' missing from {args.config}")
        app_dir = args.app_dir or config.get("app_dir") or "."
        findings = collect_findings(app_dir)
        result = apply_policy(findings, mode_cfg, base, exc)
    except PolicyError as exc_err:
        print(f"ERROR: {exc_err}", file=sys.stderr)
        return 2

    _print_summary(result, args.mode)

    if args.sarif:
        with open(args.sarif, "w", encoding="utf-8") as fh:
            json.dump(to_sarif(result.findings), fh, indent=2)
        print(f"\nSARIF written to {args.sarif}")
    if args.json_out:
        payload = [vars(f) for f in result.findings]
        with open(args.json_out, "w", encoding="utf-8") as fh:
            json.dump(payload, fh, indent=2)
        print(f"JSON written to {args.json_out}")

    if result.blocking:
        print(f"\nFAIL: {len(result.blocking)} blocking finding(s) for mode '{args.mode}'.")
        return 1
    print(f"\nPASS: no blocking findings for mode '{args.mode}'.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
