# `.ci/security`

Maintainable, dependency-free (Python stdlib only) policy scripts used by the
security workflows in `.github/workflows/`. Full documentation lives in
[`/SECURITY_PIPELINE.md`](../../SECURITY_PIPELINE.md).

| File | Purpose |
| ---- | ------- |
| `mobile_policy.py` | Android/iOS release-configuration gate (SARIF + JSON output). |
| `sca_gate.py` | Severity gate over a Trivy JSON report. |
| `mobsf_scan.py` | MobSF upload → scan → report download → gate (`MOBSF_URL`/`MOBSF_API_KEY`). |
| `policy_config.json` | Per-mode (pr/main/release) thresholds for all gates. |
| `baseline.json` | Pre-existing mobile-config findings (reported, not blocked, on pr/main). |
| `exceptions.json` | Time-boxed, documented risk acceptances (suppress in all modes until expiry). |
| `tests/` | `unittest` suite for the gate logic. |

Run locally:

```bash
python3 .ci/security/mobile_policy.py --mode pr
python3 -m unittest discover -s .ci/security/tests -p "test_*.py"
```
