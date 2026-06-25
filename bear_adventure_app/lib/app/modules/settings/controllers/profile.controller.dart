import 'package:bear_adventure_app/app/modules/settings/controllers/navigation/settings_navigation.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:profanity_filter/profanity_filter.dart';

class ProfileController extends GetxController {
  ProfileController({required this.service, required this.urlService});
  final ProfilesService service;
  final UrlService urlService;

  late final SettingsNavigation navigation;

  late final Rx<Profile> selectedProfile;

  late final RxBool isNew;

  final RxBool firstView = true.obs;
  final RxBool nameIsValid = false.obs;

  late final TextEditingController textEditingController =
      TextEditingController(
    text: "",
  );

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    navigation =
        SettingsNavigation(profilesService: service, urlService: urlService);

    firstView(service.profiles.isEmpty);

    selectedProfile = service.editingProfile;
    isNew = service.isNew;

    if (isNew()) {
      final analytics = FirebaseAnalytics.instance;
      analytics.logEvent(name: "create_profile", parameters: {
        "index": service.profiles.length + 1,
      });
      analytics.logSignUp(signUpMethod: "create_profile");
    }
    textEditingController.addListener(onProfileNameChange);
    textEditingController.text = selectedProfile.value.name;

    super.onInit();
  }

  @override
  void onClose() {
    textEditingController.removeListener(onProfileNameChange);
    textEditingController.dispose();
    super.onClose();
  }

  Future<void> completeProfile() async {
    final bool showGuide = firstView();
    if (isNew()) {
      await service.addProfile(selectedProfile());
    }
    Get.close();
    if (showGuide) {
      navigation.viewGuide();
    } else {
      navigation.goHome();
    }
  }

  /// Navigates back to the analytics consent page during onboarding.
  void goBack() {
    Get.close();
    navigation.viewAnalyticsConsent();
  }

  void onProfileNameChange() {
    Future.delayed(
        1.milliseconds,
        () => nameIsValid(
            formKey.currentState != null && formKey.currentState!.validate()));
  }

  Future<void> updateProfileName() async {
    await service.changeProfileName(
        selectedProfile(), textEditingController.text);
  }

  Future<void> addProfileDecoration(ProfileDecoration newDecoration) async {
    await service.addProfileDecoration(selectedProfile(), newDecoration);
  }

  Future<void> changeProfileColour(ProfileColour colour) async {
    await service.changeProfileColour(selectedProfile(), colour);
  }

  String? nameValidator(String? value) {
    bool isEmpty = (value == null || value.isEmpty);

    final filter = ProfanityFilter();

    return isEmpty
        ? "Name cannot be empty"
        : filter.hasProfanity(value.toLowerCase())
            ? "The name you have chosen is not allowed."
            : null;
  }
}
