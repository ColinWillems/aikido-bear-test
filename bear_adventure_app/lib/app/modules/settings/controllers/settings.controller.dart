import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:bear_adventure_app/app/modules/settings/controllers/navigation/settings_navigation.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter_app_utils/flutter_app_utils.dart';
import 'package:get/get.dart';

enum SoundSetting {
  on,
  off;
}

class SettingsController extends GetxController {
  SettingsController(
      {required this.settingsService,
      required this.profilesService,
      required this.urlService});

  final SettingsService settingsService;
  final ProfilesService profilesService;
  final UrlService urlService;

  late final SettingsNavigation navigation;

  @override
  Future<void> onInit() async {
    navigation = SettingsNavigation(
        profilesService: profilesService, urlService: urlService);

    super.onInit();
  }

  void clearData() async {
    OkCancelResult userConfirmed = await showOkCancelAlertDialog(
      context: Get.context!,
      defaultType: OkCancelAlertDefaultType.cancel,
      title: "Clear App Data",
      message:
          "this will clear all app data including collected cards and activity progress. are you sure?",
      isDestructiveAction: true,
      okLabel: "Delete",
    );
    if (userConfirmed == OkCancelResult.ok) {
      await profilesService.deleteAllProfiles();
      await settingsService.clearImageCache();
      await settingsService.deleteSharedPreferences();
      await settingsService.deleteAppDir();
      navigation.viewWelcome();
    }
  }
}
