import 'package:bear_adventure_app/app/modules/support/controllers/privacy_policy.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter_app_utils/flutter_app_utils.dart';
import 'package:get/get.dart';

class PrivacyPolicyBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
        () => PrivacyPolicyController(
          settingsService: Get.find<SettingsService>(),
          profilesService: Get.find<ProfilesService>(),
          urlService: Get.find<UrlService>(),
          permissionsService: Get.find<PermissionsService>(),
        ),
      ),
    ];
  }
}
