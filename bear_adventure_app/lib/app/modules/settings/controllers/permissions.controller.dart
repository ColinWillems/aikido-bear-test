import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsController extends GetxController {
  PermissionsController({required this.service, required this.profilesService});
  final PermissionsService service;
  final ProfilesService profilesService;

  Rx<PermissionStatus> cameraPermission = PermissionStatus.denied.obs;

  final stepsKey = GlobalKey<IntroductionScreenState>();
  final RxInt currentStep = 0.obs;
  final RxBool isLastStep = false.obs;
  final RxBool isFirstStep = true.obs;
  final RxBool isCameraPermissionChecked = false.obs;
  final RxString welcomeName = "".obs;
  late final bool firstView;

  static const int cameraPermissionsPageIndex = 0;

  @override
  void onInit() async {
    firstView = profilesService.profiles.isEmpty;
    cameraPermission = service.cameraPermission;
    isCameraPermissionChecked(cameraPermission().isGranted);

    super.onInit();
  }

  void checkPermissionsAndCloseDialog() async {
    await service.checkCameraPermissions();
    Get.close();
  }

  void finishGuide() {
    Get.close();
  }

  void previousStep() {
    stepsKey.currentState?.previous();
  }

  void nextStep() {
    final newIndex = currentStep();
    if (newIndex == cameraPermissionsPageIndex &&
        !isCameraPermissionChecked()) {
      isCameraPermissionChecked(true);
      service.checkCameraPermissions();
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
