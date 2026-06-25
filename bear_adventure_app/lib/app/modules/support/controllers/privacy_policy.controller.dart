import 'package:bear_adventure_app/app/modules/support/controllers/navigation/support_navigation.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter_app_utils/flutter_app_utils.dart';
import 'package:get/get.dart';

class PrivacyPolicyController extends GetxController {
  PrivacyPolicyController(
      {required this.settingsService,
      required this.profilesService,
      required this.urlService,
      required this.permissionsService});
  final SettingsService settingsService;
  final ProfilesService profilesService;
  final UrlService urlService;
  final PermissionsService permissionsService;

  late final SupportNavigation navigation;

  final RxBool accepted = false.obs;
  final RxBool firstView = true.obs;

  @override
  void onInit() {
    navigation = SupportNavigation(
        urlService: urlService, permissionsService: permissionsService);

    firstView(profilesService.profiles.isEmpty);

    super.onInit();
  }

  void accept(bool userAccepted) {
    accepted.value = userAccepted;
  }

  void closeDialog() {
    Get.close();
    if (firstView()) {
      navigation.viewAnalyticsConsent();
    }
  }
}
