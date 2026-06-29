"""Unit tests for mobile_policy.py (stdlib unittest, no external deps)."""

import datetime as dt
import os
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import mobile_policy as mp  # noqa: E402

MANIFEST_INSECURE = """<?xml version="1.0"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          xmlns:tools="http://schemas.android.com/tools"
          package="com.example">
  <uses-permission android:name="android.permission.INTERNET"/>
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
  <application android:debuggable="true" android:usesCleartextTraffic="true"
               android:allowBackup="true">
    <activity android:name=".MainActivity" android:exported="true">
      <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
      </intent-filter>
      <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="myapp" android:host="card"/>
      </intent-filter>
    </activity>
    <service android:name=".SyncService" android:exported="true"/>
    <provider android:name=".Fp" android:exported="false"/>
  </application>
  <queries>
    <intent>
      <action android:name="android.intent.action.VIEW"/>
      <data android:scheme="mailto"/>
    </intent>
  </queries>
</manifest>
"""

MANIFEST_SECURE = """<?xml version="1.0"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          package="com.example">
  <uses-permission android:name="android.permission.INTERNET"/>
  <application android:allowBackup="false">
    <activity android:name=".MainActivity" android:exported="true">
      <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
      </intent-filter>
    </activity>
  </application>
</manifest>
"""

GRADLE_INSECURE = """
android {
  defaultConfig { minSdkVersion 19  targetSdkVersion 28 }
  buildTypes { release { debuggable true  signingConfig signingConfigs.debug } }
}
"""

GRADLE_SECURE = """
android {
  defaultConfig { minSdkVersion 24  targetSdkVersion 36 }
  buildTypes { release { minifyEnabled true  shrinkResources true
      signingConfig signingConfigs.release } }
}
"""

INFO_PLIST_INSECURE = """<?xml version="1.0"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>NSAppTransportSecurity</key>
  <dict><key>NSAllowsArbitraryLoads</key><true/>
    <key>NSExceptionDomains</key>
    <dict><key>insecure.example.com</key>
      <dict><key>NSExceptionAllowsInsecureHTTPLoads</key><true/></dict></dict>
  </dict>
  <key>CFBundleURLTypes</key>
  <array><dict><key>CFBundleURLSchemes</key><array><string>myapp</string></array></dict></array>
</dict></plist>
"""

INFO_PLIST_SECURE = """<?xml version="1.0"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>CFBundleName</key><string>App</string>
</dict></plist>
"""

ENTITLEMENTS_DEV = """<?xml version="1.0"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>aps-environment</key><string>development</string>
  <key>get-task-allow</key><true/>
</dict></plist>
"""


def _write(tmp, name, content, binary=False):
    path = os.path.join(tmp, name)
    mode = "wb" if binary else "w"
    with open(path, mode) as fh:
        fh.write(content.encode() if binary else content)
    return path


class AndroidManifestTests(unittest.TestCase):
    def _ids(self, content):
        with tempfile.TemporaryDirectory() as tmp:
            path = _write(tmp, "AndroidManifest.xml", content)
            return {f.id for f in mp.check_android_manifest(path)}

    def test_insecure_manifest_flags_expected_rules(self):
        ids = self._ids(MANIFEST_INSECURE)
        self.assertIn("ANDROID_DEBUGGABLE", ids)
        self.assertIn("ANDROID_CLEARTEXT_TRAFFIC", ids)
        self.assertIn("ANDROID_BACKUP_ENABLED", ids)
        self.assertIn("ANDROID_EXPORTED_COMPONENT", ids)  # SyncService
        self.assertIn("ANDROID_DANGEROUS_PERMISSION", ids)
        self.assertIn("ANDROID_CUSTOM_SCHEME_DEEPLINK", ids)

    def test_launcher_activity_not_flagged_as_exported(self):
        # MainActivity is exported but has LAUNCHER intent -> must not flag.
        findings = self._ids(MANIFEST_SECURE)
        self.assertNotIn("ANDROID_EXPORTED_COMPONENT", findings)

    def test_mailto_query_is_not_a_custom_scheme_deeplink(self):
        # The <queries> mailto intent must not be treated as a deep link.
        ids = self._ids(MANIFEST_INSECURE)
        custom = [f for f in mp.check_android_manifest(
            _write(tempfile.mkdtemp(), "AndroidManifest.xml", MANIFEST_INSECURE))
            if f.id == "ANDROID_CUSTOM_SCHEME_DEEPLINK"]
        self.assertEqual(len(custom), 1)
        self.assertIn("myapp", custom[0].detail)

    def test_secure_manifest_is_clean(self):
        self.assertEqual(self._ids(MANIFEST_SECURE), set())


class AndroidGradleTests(unittest.TestCase):
    def _ids(self, content):
        with tempfile.TemporaryDirectory() as tmp:
            path = _write(tmp, "build.gradle", content)
            return {f.id for f in mp.check_android_gradle(path)}

    def test_insecure_gradle(self):
        ids = self._ids(GRADLE_INSECURE)
        self.assertIn("ANDROID_RELEASE_NO_MINIFY", ids)
        self.assertIn("ANDROID_RELEASE_DEBUGGABLE", ids)
        self.assertIn("ANDROID_DEBUG_SIGNING", ids)
        self.assertIn("ANDROID_OBSOLETE_MIN_SDK", ids)
        self.assertIn("ANDROID_OBSOLETE_TARGET_SDK", ids)

    def test_secure_gradle(self):
        self.assertEqual(self._ids(GRADLE_SECURE), set())


class IosTests(unittest.TestCase):
    def test_info_plist_insecure(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = _write(tmp, "Info.plist", INFO_PLIST_INSECURE, binary=True)
            ids = {f.id for f in mp.check_ios_info_plist(path)}
        self.assertIn("IOS_ATS_ARBITRARY_LOADS", ids)
        self.assertIn("IOS_ATS_EXCEPTION_DOMAIN", ids)
        self.assertIn("IOS_CUSTOM_URL_SCHEME", ids)

    def test_info_plist_secure(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = _write(tmp, "Info.plist", INFO_PLIST_SECURE, binary=True)
            self.assertEqual(mp.check_ios_info_plist(path), [])

    def test_entitlements_dev(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = _write(tmp, "Runner.entitlements", ENTITLEMENTS_DEV, binary=True)
            ids = {f.id for f in mp.check_ios_entitlements(path)}
        self.assertIn("IOS_APS_ENV_DEVELOPMENT", ids)
        self.assertIn("IOS_DEBUG_ENTITLEMENT", ids)


class PolicyTests(unittest.TestCase):
    def setUp(self):
        self.findings = [
            mp.Finding("CRIT", "CRITICAL", "c", "d", "f"),
            mp.Finding("HI", "HIGH", "h", "d", "f"),
            mp.Finding("MEDcfg", "MEDIUM", "m", "d", "f", mobile_config=True),
            mp.Finding("LOWinfo", "LOW", "l", "d", "f", mobile_config=False),
        ]

    def _fresh(self):
        return [mp.Finding(f.id, f.severity, f.title, f.detail, f.location, f.mobile_config)
                for f in self.findings]

    def test_pr_blocks_high_and_critical_only(self):
        cfg = {"block_severities": ["CRITICAL", "HIGH"], "honor_baseline": True,
               "block_mobile_config": False}
        res = mp.apply_policy(self._fresh(), cfg, set(), {})
        self.assertEqual({f.id for f in res.blocking}, {"CRIT", "HI"})

    def test_baseline_downgrades_to_reported(self):
        cfg = {"block_severities": ["CRITICAL", "HIGH"], "honor_baseline": True,
               "block_mobile_config": False}
        res = mp.apply_policy(self._fresh(), cfg, {"HI"}, {})
        self.assertEqual({f.id for f in res.blocking}, {"CRIT"})
        self.assertIn("HI", {f.id for f in res.reported})

    def test_release_ignores_baseline_and_blocks_mobile_config(self):
        cfg = {"block_severities": ["CRITICAL", "HIGH"], "honor_baseline": False,
               "block_mobile_config": True}
        res = mp.apply_policy(self._fresh(), cfg, {"HI", "MEDcfg"}, {})
        # MEDcfg is mobile_config -> blocks on release despite being baselined.
        self.assertEqual({f.id for f in res.blocking}, {"CRIT", "HI", "MEDcfg"})

    def test_exception_suppresses_in_all_modes(self):
        cfg = {"block_severities": ["CRITICAL", "HIGH"], "honor_baseline": False,
               "block_mobile_config": True}
        res = mp.apply_policy(self._fresh(), cfg, set(), {"CRIT": "approved"})
        self.assertNotIn("CRIT", {f.id for f in res.blocking})
        self.assertIn("CRIT", {f.id for f in res.suppressed})


class ExceptionExpiryTests(unittest.TestCase):
    def test_expired_exception_ignored(self):
        doc = {"exceptions": [{"id": "X", "reason": "r", "owner": "o",
                               "expires": "2000-01-01"}]}
        self.assertEqual(mp.active_exception_ids(doc, dt.date(2026, 1, 1)), {})

    def test_active_exception_returned(self):
        doc = {"exceptions": [{"id": "X", "reason": "r", "owner": "o",
                               "expires": "2999-01-01"}]}
        self.assertIn("X", mp.active_exception_ids(doc, dt.date(2026, 1, 1)))

    def test_incomplete_exception_ignored(self):
        doc = {"exceptions": [{"id": "X", "expires": "2999-01-01"}]}
        self.assertEqual(mp.active_exception_ids(doc, dt.date(2026, 1, 1)), {})

    def test_malformed_date_ignored(self):
        doc = {"exceptions": [{"id": "X", "reason": "r", "owner": "o",
                               "expires": "not-a-date"}]}
        self.assertEqual(mp.active_exception_ids(doc, dt.date(2026, 1, 1)), {})


class SarifTests(unittest.TestCase):
    def test_sarif_shape_and_suppressions(self):
        findings = [mp.Finding("A", "HIGH", "t", "d", "f", status="blocking"),
                    mp.Finding("B", "LOW", "t", "d", "f", status="reported",
                               suppress_reason="baselined")]
        sarif = mp.to_sarif(findings)
        self.assertEqual(sarif["version"], "2.1.0")
        results = sarif["runs"][0]["results"]
        self.assertEqual(len(results), 2)
        suppressed = [r for r in results if "suppressions" in r]
        self.assertEqual(len(suppressed), 1)


if __name__ == "__main__":
    unittest.main()
