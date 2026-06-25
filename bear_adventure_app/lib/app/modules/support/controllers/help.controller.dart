import 'dart:io';

import 'package:bear_adventure_app/app/modules/support/controllers/navigation/support_navigation.dart';
import 'package:bear_adventure_app/app/services/deferred_deep_link.service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class HelpController extends GetxController {
  HelpController({
    required this.profilesService,
    required this.permissionsService,
    required this.deepLinkService,
    required this.deferredDeepLinkService,
    required this.urlService,
  });

  final ProfilesService profilesService;
  final PermissionsService permissionsService;
  final DeepLinkService deepLinkService;
  final DeferredDeepLinkService deferredDeepLinkService;
  final UrlService urlService;

  Rx<PermissionStatus> cameraPermission = PermissionStatus.denied.obs;

  final stepsKey = GlobalKey<IntroductionScreenState>();
  final RxInt currentStep = 0.obs;
  final RxBool isLastStep = false.obs;
  final RxBool isFirstStep = true.obs;
  final RxBool isCameraPermissionChecked = false.obs;
  final RxBool isPasteboardPermissionChecked = false.obs;
  final RxString welcomeName = "".obs;

  static const int cameraPermissionsPageIndex = 2;
  static int get pasteboardPermissionsPageIndex =>
      Platform.isIOS ? 4 : -1; // Only on iOS, after summary

  late final SupportNavigation navigation;

  @override
  Future<void> onInit() async {
    navigation = SupportNavigation(
        urlService: urlService, permissionsService: permissionsService);
    cameraPermission = permissionsService.cameraPermission;
    isCameraPermissionChecked(cameraPermission().isGranted);
    welcomeName(profilesService.activeProfile().name);

    // On Android, fetch the deferred deeplink from Play Install Referrer
    if (Platform.isAndroid) {
      await deferredDeepLinkService.getAndroidDeferredDeepLink();
    }

    super.onInit();
  }

  void checkCameraPermissionsAndCloseDialog() async {
    permissionsService.checkCameraPermissions();
    Get.close();
  }

  Future<void> requestPasteboardAccess() async {
    // On iOS, reading the pasteboard will trigger the system prompt
    await deferredDeepLinkService.getIOSDeferredDeepLink();
    isPasteboardPermissionChecked(true);
  }

  void finishGuide() {
    Get.close(closeAll: false);
    // Prefer a direct deep link (universal/app link or custom scheme) over a
    // deferred one — both ultimately resolve to a plaintext card id.
    final Uri? deepLink = deepLinkService.deepLink();
    String? cardId;
    if (deepLink != null) {
      cardId = BearApp.tryExtractCardId(deepLink);
    }
    cardId ??= deferredDeepLinkService.deferredPath();
    if (cardId != null && cardId.isNotEmpty) {
      navigation.captureCard(deepLink: BearApp.buildCardUnlockUrl(cardId));
    } else {
      navigation.goHome();
    }
  }

  void previousStep() {
    stepsKey.currentState?.previous();
  }

  void nextStep() {
    final newIndex = currentStep();
    if (newIndex == cameraPermissionsPageIndex &&
        !isCameraPermissionChecked()) {
      isCameraPermissionChecked(true);
      permissionsService.checkCameraPermissions();
    } else if (Platform.isIOS &&
        newIndex == pasteboardPermissionsPageIndex &&
        !isPasteboardPermissionChecked()) {
      requestPasteboardAccess();
    } else {
      stepsKey.currentState?.next();
    }
  }

  void goToStep(int stepIndex) {
    stepsKey.currentState?.animateScroll(stepIndex);
  }

  void onStepChange(int newIndex) {
    int numPages = stepsKey.currentState?.getPagesLength() ?? 1;

    currentStep(newIndex);
    isFirstStep(currentStep() == 0);
    isLastStep(currentStep() == (numPages - 1));
  }
}
