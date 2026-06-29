# Security pipeline — BEAR Adventure

This document describes the mobile security scanning pipeline for the BEAR
Adventure repository: what runs where, what blocks, the secrets/variables it
needs, how to run checks locally, how to read reports, and how to accept a risk
temporarily. It complements the build/release docs in
[`docs/CICD.md`](docs/CICD.md).

The pipeline reuses the repository's existing CI platform (**GitHub Actions**)
and build commands (**Flutter** + **Fastlane**). It does not migrate platforms
or replace the existing release lanes.

## 1. Detected applications and technologies

| Component | Path | Tech | Package managers |
| --------- | ---- | ---- | ---------------- |
| **BEAR Adventure app** (mobile) | `bear_adventure_app/` | Flutter (Dart) → Android (Kotlin) + iOS (Swift/Obj-C) | pub, Gradle, CocoaPods, Bundler |
| Firebase Cloud Functions | `fir-functions/functions/` | Node.js 22 (JavaScript) | npm |
| Landing page | `bear_adventure_landing_page/` | Next.js (TypeScript/React) — hosts the `assetlinks.json` / `apple-app-site-association` deep-link files | npm |
| Build / translation scripts | `scripts/` | Python (+ 1 Dart helper) | pip |
| Local Dart packages | `packages/` | Dart | pub |

- **App identity:** `com.bearsnacks.bearadventure`
- **Branches / release flow:** PR → `main` (checks only); push `builds/staging`
  → Play internal / TestFlight; push `builds/production` → Play production /
  App Store upload. iOS signing via fastlane **match**; Android via an upload
  keystore injected from secrets.
- **The only first-class mobile application is the Flutter app**; there are no
  React Native / MAUI / Xamarin / Unity / KMP targets. There are native C/C++
  desugaring libs only (no first-party native modules).

## 2. What runs, and when

| Workflow | Trigger | Purpose |
| -------- | ------- | ------- |
| `security-pr.yml` | PR → `main`, `builds/staging`, `builds/production` | Fast, diff-aware checks. |
| `codeql.yml` | PR, push `main`, weekly | CodeQL deep SAST for JS/TS + Python. |
| `security-main.yml` | push `main`, weekly, manual | Full SAST/SCA, SBOM, artifact builds, MobSF. |
| `security-release.yml` | push `builds/production`, manual, `workflow_call` | Strict release gate (protected env). |

### Pull-request checks (`security-pr.yml`)
Independent jobs run in parallel; long jobs have timeouts; reports upload with
`always()`.

- **Secret scanning** — Gitleaks (`.gitleaks.toml`), full-history diff.
- **SAST** — Semgrep (diff-aware vs the PR base) across Dart, Kotlin, Swift,
  JS, TS, Python + secrets; SARIF uploaded to the code-scanning dashboard.
- **CodeQL** — JS/TS + Python (`codeql.yml`).
- **Dart** — `flutter analyze` + `flutter test` (includes the deep-link /
  unlock-URL security tests).
- **Firebase Functions** — ESLint (reported, non-blocking; Semgrep is the
  blocking JS gate).
- **Dependency & license review** — `dependency-review-action`, fails on new
  High+ vulnerable dependencies.
- **Mobile config policy** — `mobile_policy.py --mode pr` (SARIF + JSON).
- **Policy-script unit tests** — validates the gate logic itself.

> Native artifact builds (Android Lint, `xcodebuild analyze`, MobSF) are
> **deliberately not** on PRs. This matches the project's documented decision
> to keep PR CI fast and let real builds catch native issues
> (`docs/CICD.md`). They run on `main` instead.

### Main-branch / scheduled checks (`security-main.yml`)
- **Full-repo Semgrep** (not diff-only) — SARIF + ERROR-severity gate.
- **Full SCA** — Trivy filesystem scan over resolved lockfiles
  (`pubspec.lock`, `Podfile.lock`, `package-lock.json`, `Gemfile.lock`,
  Gradle) → `sca_gate.py --mode main`.
- **SBOM** — CycloneDX JSON via Syft (`anchore/sbom-action`), uploaded as an
  artifact.
- **Android** — builds release-like **APK + AAB** using a *scan-only throwaway
  keystore* (the real upload keystore is never present outside the release
  environment), runs **Android Lint (release)**, **mobile config policy
  (main)**, and **MobSF** on the APK when configured.
- **iOS** — `xcodebuild analyze` (no signing) + an **unsigned IPA** packaged
  for static analysis, scanned with **MobSF** when configured.
- MobSF JSON + PDF reports are preserved as CI artifacts.

### Release checks (`security-release.yml`)
Runs against the exact release candidate in the protected **`production`**
environment (manual approval + branch restriction). Production signing secrets
are referenced **only** in this workflow.

- Gitleaks (verified secrets), Semgrep ERROR gate, Trivy SCA
  (`sca_gate.py --mode release`).
- **Mobile config policy (release)** — blocks all explicit mobile-config
  violations (baseline is ignored; only documented exceptions suppress).
- **Package/bundle identity** verification (`applicationId` / `BUNDLE_ID` ==
  `com.bearsnacks.bearadventure`).
- **Android signing identity** — decodes the keystore from the release-env
  secret, asserts the expected alias exists, prints only the public SHA-256
  fingerprint, then deletes the keystore.
- **iOS entitlements** sanity check (full provisioning validation is available
  via the existing `fastlane ios validate_signing` lane — see follow-ups).

## 3. Blocking rules (finding policy)

Thresholds live in [`.ci/security/policy_config.json`](.ci/security/policy_config.json).

| | Pull request | Main | Release |
| --- | --- | --- | --- |
| Verified secrets | block | block | block |
| SAST (Semgrep/CodeQL) | block new high-confidence (ERROR) | block ERROR (critical) | block ERROR |
| New vulnerable deps | block High+ (fixable) | block Critical | block Critical + exploitable High |
| Mobile config rules | reported (baseline) | block new; baseline reported | **block all** (baseline ignored) |
| Existing baseline findings | reported | reported | require an exception |

Mobile config rules emitted by `mobile_policy.py` include: Android
`debuggable`/cleartext/`allowBackup`/exported components/dangerous
permissions/custom-scheme deep links/missing R8 minify/obsolete min/target
SDK/debug signing; iOS broad ATS / per-domain ATS exceptions / dev
`aps-environment` / `get-task-allow` debug entitlement / custom URL schemes.

### Current baseline (this repo)
`baseline.json` accepts these pre-existing findings (reported on PR/main,
**blocking on release** until fixed or excepted):

- `IOS_ATS_ARBITRARY_LOADS` — `NSAllowsArbitraryLoads=true` in `Info.plist`.
- `IOS_APS_ENV_DEVELOPMENT` — `aps-environment=development` in entitlements.
- `ANDROID_RELEASE_NO_MINIFY` — release build has no R8 minify/shrink.
- `ANDROID_CUSTOM_SCHEME_DEEPLINK` — `bearadventure://` scheme in the prod manifest.

## 4. Required CI secrets and variables

MobSF (optional but required to enforce binary scanning):

| Name | Type | Used by | Notes |
| ---- | ---- | ------- | ----- |
| `MOBSF_URL` | secret/variable | main, release | Base URL of the MobSF server. |
| `MOBSF_API_KEY` | secret | main, release | MobSF REST API key (never logged). |

Release signing (must exist **only** in the protected `production`
environment — see `docs/CICD.md` §4):

`ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_PASSWORD`,
`ANDROID_KEY_ALIAS`, `PLAY_STORE_JSON_KEY_BASE64`, `MATCH_REPO_SSH_KEY`,
`MATCH_GIT_URL`, `MATCH_PASSWORD`, `APPLE_TEAM_ID`,
`APP_STORE_CONNECT_API_KEY_ID`, `APP_STORE_CONNECT_API_ISSUER_ID`,
`APP_STORE_CONNECT_API_KEY_P8_BASE64`.

`GITHUB_TOKEN` is provided automatically. The PR and main workflows never
reference signing secrets.

## 5. Running important checks locally

```bash
# Mobile config policy (no external dependencies)
python3 .ci/security/mobile_policy.py --mode pr        # PR rules
python3 .ci/security/mobile_policy.py --mode release   # strict release rules

# Policy script unit tests
python3 -m unittest discover -s .ci/security/tests -p "test_*.py" -v

# Semgrep (same rulesets as CI)
pipx run semgrep scan --config p/default --config p/secrets --config p/dart \
  --config p/kotlin --config p/swift --config p/javascript \
  --config p/typescript --config p/python

# Gitleaks
gitleaks detect --config .gitleaks.toml --redact

# Trivy SCA + gate
trivy fs --scanners vuln --format json -o trivy.json .
python3 .ci/security/sca_gate.py --report trivy.json --mode pr

# Flutter analysis + tests
cd bear_adventure_app && flutter pub get && flutter analyze && flutter test

# MobSF scan of a built artifact
export MOBSF_URL=... MOBSF_API_KEY=...
python3 .ci/security/mobsf_scan.py --file path/to/app-release.apk --mode main
```

## 6. Reviewing reports

- **Code scanning dashboard** (repo → *Security → Code scanning*): Semgrep,
  CodeQL, Trivy and mobile-policy SARIF, grouped by `category`.
- **Workflow artifacts** (a run's *Summary → Artifacts*): `semgrep-*-sarif`,
  `trivy-sca`, `sbom-repository.cyclonedx.json`, `mobile-policy-*`,
  `android-scan`, `ios-scan` (incl. MobSF JSON/PDF), `release-gate-reports`.
- **PR comments**: dependency-review posts a summary on failure.

## 7. Creating a temporary risk exception

Add an entry to [`.ci/security/exceptions.json`](.ci/security/exceptions.json).
It suppresses the finding in **all** modes (including release) until `expires`;
expired or incomplete entries are ignored automatically (the finding starts
blocking again). All four fields are required.

```json
{
  "exceptions": [
    {
      "id": "IOS_ATS_ARBITRARY_LOADS",
      "reason": "Legacy CMS endpoint served over HTTP; migration tracked in JIRA-123.",
      "owner": "security@bearsnacks.example",
      "expires": "2026-09-30"
    }
  ]
}
```

Use `baseline.json` (no expiry) only for the initial adoption sweep; prefer
fixing or adding a dated exception.

## 8. Troubleshooting

- **Release gate fails on `IOS_ATS_ARBITRARY_LOADS` / `IOS_APS_ENV_DEVELOPMENT`
  / `ANDROID_RELEASE_NO_MINIFY`** — expected: these are baselined for PR/main
  but block release. Fix the config or add a dated exception (§7).
- **`mobile_policy.py` exits 2** — a config file is missing/malformed or
  `--app-dir` is wrong; the stderr message names the file.
- **Semgrep gate fails but SARIF is empty** — the gate step re-scans at
  `--severity ERROR`; lower-severity findings appear in the dashboard only.
- **MobSF steps skipped** — `MOBSF_URL`/`MOBSF_API_KEY` not set. Scans are
  skipped (with a warning) rather than failing builds that lack the server.
- **Android scan build can't sign** — the main-branch job creates a throwaway
  keystore in `$RUNNER_TEMP`; it is deleted in the cleanup step. It is **not**
  a distribution key.
- **`flutter pub get` fails on a git dependency** — `camerawesome` /
  `decorated_text` are unpinned git deps (`ref: HEAD`); see follow-ups.

## 9. Assumptions, limitations, follow-up work

**Assumptions**
- GitHub Actions is the CI provider and the documented branch/environment model
  (`main`, `builds/staging`, `builds/production`; `staging`/`production`
  environments) is authoritative. `.github/` was absent from the repo, so these
  workflows were created fresh to match `docs/CICD.md`.
- Committed Firebase client config is public-by-design (per `docs/CICD.md` §10)
  and is allowlisted in `.gitleaks.toml`.

**Limitations (not executed in the authoring sandbox)**
- The scanners themselves (Semgrep, Gitleaks, Trivy, CodeQL, MobSF, Flutter,
  Gradle, Xcode) could not run locally — no Flutter/Java/Xcode toolchain and a
  network-restricted environment. **Validated locally:** all workflow YAML
  parses; every action is pinned to a 40-char commit SHA; the Python policy
  scripts run against the real repo and their 28 unit tests pass.
- CocoaPods has no Dependabot ecosystem; Pods are covered by the main-branch
  SCA/SBOM/MobSF jobs instead.
- CodeQL covers JS/TS + Python only (Dart unsupported; Kotlin/Swift would need
  a build step). Semgrep + Android Lint + `xcodebuild analyze` cover the rest.

**Follow-up work**
- Remediate the baselined findings (scope ATS to specific domains; confirm
  production APS environment; enable R8 minify + a verified ProGuard config;
  move the `bearadventure://` test scheme to a debug-only manifest), then remove
  them from `baseline.json`.
- Pin the git dependencies (`camerawesome`, `decorated_text`) to a commit/tag
  and add Gradle dependency verification/locking.
- Add a macOS `fastlane ios validate_signing` job as a required release gate for
  full provisioning-profile validation, and wire the existing publish lanes to
  `needs:` the release gate.
- Add dynamic security smoke tests (emulator/simulator install + deep-link,
  log-secret, screenshot and WebView checks) once reliable device-test
  infrastructure exists — intentionally omitted here to avoid fragile,
  build-blocking jobs (per the task constraints).
