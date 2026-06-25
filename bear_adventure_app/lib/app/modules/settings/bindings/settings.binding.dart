import 'package:bear_adventure_app/app/modules/settings/controllers/settings.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter_app_utils/services/services.dart';
import 'package:get/get.dart';

class SettingsBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
        () => SettingsController(
          settingsService: Get.find<SettingsService>(),
          profilesService: Get.find<ProfilesService>(),
          urlService: Get.find<UrlService>(),
        ),
      ),
    ];
  }
}
