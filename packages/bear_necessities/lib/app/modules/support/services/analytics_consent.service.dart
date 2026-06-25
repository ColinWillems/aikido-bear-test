import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service that manages the user's consent for Firebase Analytics, Crashlytics
/// and Performance Monitoring data collection.
///
/// Until consent has been recorded, all three Firebase products are kept
/// disabled. The service exposes a single [consentGiven] flag and a single
/// [hasMadeChoice] flag (so the UI can distinguish between "user has not made
/// a choice yet" and "user has explicitly opted out").
class AnalyticsConsentService extends GetxService {
  AnalyticsConsentService();

  /// SharedPreferences key for the recorded consent value.
  static const String _consentKey = 'analytics_consent_given';

  /// SharedPreferences key recording whether the user made an explicit choice.
  static const String _consentChoiceMadeKey = 'analytics_consent_choice_made';

  /// Whether the user has actively chosen to allow analytics collection.
  final RxBool consentGiven = false.obs;

  /// Whether the user has made an explicit choice (regardless of value).
  /// While this is `false` we have to keep all analytics disabled and prompt
  /// the user during onboarding.
  final RxBool hasMadeChoice = false.obs;

  /// Initialize the service by loading the persisted consent state and
  /// applying it to the underlying Firebase products. This MUST be called
  /// before any analytics/crashlytics/performance data is logged so that we
  /// never collect data without consent.
  Future<AnalyticsConsentService> init() async {
    final prefs = await SharedPreferences.getInstance();
    hasMadeChoice.value = prefs.getBool(_consentChoiceMadeKey) ?? false;
    consentGiven.value = prefs.getBool(_consentKey) ?? false;

    // Until the user has explicitly opted in, keep collection disabled.
    final bool enabled = hasMadeChoice.value && consentGiven.value;
    await _applyToFirebase(enabled);

    return this;
  }

  /// Record the user's choice and apply it to Firebase. Persists the choice
  /// so it survives app restarts.
  Future<void> setConsent(bool enabled) async {
    consentGiven.value = enabled;
    hasMadeChoice.value = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, enabled);
    await prefs.setBool(_consentChoiceMadeKey, true);

    await _applyToFirebase(enabled);
  }

  Future<void> _applyToFirebase(bool enabled) async {
    // Firebase Analytics
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(enabled);

    // Firebase Crashlytics. The native methods are no-ops in debug mode but
    // we still call them for consistency.
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(enabled);

    // Firebase Performance Monitoring
    await FirebasePerformance.instance
        .setPerformanceCollectionEnabled(enabled);
  }
}
