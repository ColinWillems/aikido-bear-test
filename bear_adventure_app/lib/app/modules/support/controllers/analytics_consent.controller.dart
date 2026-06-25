import 'package:bear_adventure_app/app/modules/support/controllers/navigation/support_navigation.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class AnalyticsConsentController extends GetxController {
  AnalyticsConsentController({
    required this.analyticsConsentService,
    required this.profilesService,
    required this.urlService,
    required this.permissionsService,
  });

  final AnalyticsConsentService analyticsConsentService;
  final ProfilesService profilesService;
  final UrlService urlService;
  final PermissionsService permissionsService;

  late final SupportNavigation navigation;

  /// Whether the parent/guardian consent checkbox is ticked.
  final RxBool consentChecked = false.obs;

  /// Whether this is the onboarding presentation of the screen (no profiles
  /// yet) versus a subsequent presentation from the settings page.
  final RxBool firstView = true.obs;

  @override
  void onInit() {
    navigation = SupportNavigation(
      urlService: urlService,
      permissionsService: permissionsService,
    );

    firstView(profilesService.profiles.isEmpty);

    // When opening from settings, pre-fill the checkbox with the user's
    // current consent so the screen reflects the existing choice.
    if (!firstView()) {
      consentChecked.value = analyticsConsentService.consentGiven.value;
    }

    super.onInit();
  }

  void toggleConsent(bool value) {
    consentChecked.value = value;
  }

  /// User confirmed they want analytics enabled. Only callable when the
  /// parental consent checkbox is ticked.
  Future<void> continueWithAnalytics() async {
    await analyticsConsentService.setConsent(true);
    _finish();
  }

  /// User opted out of analytics.
  Future<void> continueWithoutAnalytics() async {
    await analyticsConsentService.setConsent(false);
    _finish();
  }

  void _finish() {
    Get.close();

    if (firstView()) {
      profilesService.createProfile();
      navigation.editProfile();
    }
  }

  /// Navigates back to the privacy policy page during onboarding.
  void goBack() {
    Get.close();
    navigation.viewPrivacyPolicy();
  }
}
