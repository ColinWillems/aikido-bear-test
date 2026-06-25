import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:bear_adventure_app/app/modules/settings/controllers/navigation/settings_navigation.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ProfileAction {
  use,
  edit,
  delete;
}

class ProfilesController extends GetxController {
  ProfilesController({required this.service, required this.urlService});
  final ProfilesService service;
  final UrlService urlService;

  late final SettingsNavigation navigation;

  @override
  Future<void> onInit() async {
    navigation =
        SettingsNavigation(profilesService: service, urlService: urlService);

    profiles = service.profiles;

    activeProfile = service.activeProfile;

    super.onInit();
  }

  late final RxList<Profile> profiles;
  late final Rx<Profile> activeProfile;

  void chooseProfileAction(Profile profile) async {
    ProfileAction? response = await showModalActionSheet(
        context: Get.context!,
        style: AdaptiveStyle.material,
        title: "Choose action",
        message: "What do you want to do with this profile?",
        actions: <SheetAction<ProfileAction>>[
          const SheetAction<ProfileAction>(
            key: ProfileAction.use,
            label: "Use profile",
            isDefaultAction: true,
          ),
          const SheetAction<ProfileAction>(
            key: ProfileAction.edit,
            label: "Edit profile",
          ),
          const SheetAction<ProfileAction>(
            key: ProfileAction.delete,
            label: "Delete profile",
            isDestructiveAction: true,
          ),
        ],
        isDismissible: true);
    switch (response) {
      case ProfileAction.use:
        useProfile(profile);
        break;
      case ProfileAction.edit:
        editProfile(profile);
        break;
      case ProfileAction.delete:
        deleteProfile(profile);
        break;
      default:
        break;
    }
  }

  Future<void> deleteProfile(Profile profile) async {
    if (profiles.length == 1) {
      await Dialogs.showDialog(
        title: "Alert",
        message:
            "You cannot delete this profile because at least one active profile is required.",
        path: "/${Profiles.rootPath}/error/cannot-delete-profile-if-last",
      );
    } else {
      OkCancelResult response = await showOkCancelAlertDialog(
        context: Get.context!,
        style: AdaptiveStyle.material,
        title: "This will delete the profile for ${profile.name}",
        message: "Are you sure?",
        okLabel: "Delete",
        cancelLabel: "Cancel",
        defaultType: OkCancelAlertDefaultType.cancel,
        barrierDismissible: true,
        isDestructiveAction: true,
        routeSettings: const RouteSettings(
          name: "/${Profiles.rootPath}/delete-profile",
        ),
      );
      if (response == OkCancelResult.ok) {
        await service.deleteProfile(profile);
      }
    }
  }

  void editProfile(Profile profile) {
    service.editingProfile(profile);
    navigation.editProfileName();
  }

  void useProfile(Profile profile) {
    service.activeProfile.value = profile;
    Get.close();
    navigation.goHome();
  }

  void addProfile() {
    Profile newProfile = service.createProfile();
    editProfile(newProfile);
  }
}
