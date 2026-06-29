"""Unit tests for sca_gate.py and mobsf_scan.py gate logic (stdlib only)."""

import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import sca_gate as sca  # noqa: E402
import mobsf_scan as mobsf  # noqa: E402

TRIVY_REPORT = {
    "Results": [
        {
            "Target": "pubspec.lock",
            "Vulnerabilities": [
                {"VulnerabilityID": "CVE-1", "PkgName": "a", "InstalledVersion": "1.0",
                 "FixedVersion": "1.1", "Severity": "CRITICAL"},
                {"VulnerabilityID": "CVE-2", "PkgName": "b", "InstalledVersion": "2.0",
                 "FixedVersion": "", "Severity": "HIGH"},
                {"VulnerabilityID": "CVE-3", "PkgName": "c", "InstalledVersion": "3.0",
                 "FixedVersion": "3.1", "Severity": "MEDIUM"},
            ],
        }
    ]
}


class ExtractTests(unittest.TestCase):
    def test_extract(self):
        vulns = sca.extract_vulnerabilities(TRIVY_REPORT)
        self.assertEqual(len(vulns), 3)
        self.assertEqual(vulns[0]["id"], "CVE-1")

    def test_bad_report_raises(self):
        with self.assertRaises(sca.GateError):
            sca.extract_vulnerabilities({"nope": 1})


class EvaluateTests(unittest.TestCase):
    def setUp(self):
        self.vulns = sca.extract_vulnerabilities(TRIVY_REPORT)

    def test_pr_requires_fix_available(self):
        # PR blocks CRITICAL/HIGH but only when fixable -> CVE-2 (no fix) is reported.
        cfg = {"block_severities": ["CRITICAL", "HIGH"], "require_fix_available": True}
        blocking, reported = sca.evaluate(self.vulns, cfg, set())
        self.assertEqual({v["id"] for v in blocking}, {"CVE-1"})
        self.assertIn("CVE-2", {v["id"] for v in reported})

    def test_release_blocks_high_without_fix(self):
        cfg = {"block_severities": ["CRITICAL", "HIGH"], "require_fix_available": False}
        blocking, _ = sca.evaluate(self.vulns, cfg, set())
        self.assertEqual({v["id"] for v in blocking}, {"CVE-1", "CVE-2"})

    def test_baseline_allowlist(self):
        cfg = {"block_severities": ["CRITICAL", "HIGH"], "require_fix_available": False}
        blocking, _ = sca.evaluate(self.vulns, cfg, {"CVE-1"})
        self.assertEqual({v["id"] for v in blocking}, {"CVE-2"})

    def test_severity_counts(self):
        counts = sca.severity_counts(self.vulns)
        self.assertEqual(counts["CRITICAL"], 1)
        self.assertEqual(counts["HIGH"], 1)
        self.assertEqual(counts["MEDIUM"], 1)


class MobsfGateTests(unittest.TestCase):
    def test_parse_appsec_block(self):
        report = {"appsec": {"high": [1, 2], "warning": [1], "critical": []}}
        counts = mobsf.parse_appsec_counts(report)
        self.assertEqual(counts["high"], 2)
        self.assertEqual(counts["warning"], 1)

    def test_parse_code_analysis_fallback(self):
        report = {"code_analysis": {"findings": {
            "rule_a": {"metadata": {"severity": "high"}},
            "rule_b": {"metadata": {"severity": "warning"}},
        }}}
        counts = mobsf.parse_appsec_counts(report)
        self.assertEqual(counts["high"], 1)
        self.assertEqual(counts["warning"], 1)

    def test_release_gate_blocks_high(self):
        failures = mobsf.evaluate_gate({"critical": 0, "high": 3, "warning": 0},
                                       {"max_high": 0, "max_critical": 0})
        self.assertTrue(failures)

    def test_main_gate_allows_high(self):
        failures = mobsf.evaluate_gate({"critical": 0, "high": 3, "warning": 0},
                                       {"max_high": 9999, "max_critical": 0})
        self.assertEqual(failures, [])


if __name__ == "__main__":
    unittest.main()
