import 'dart:async';

import 'package:bear_adventure_app/app/modules/splash/controllers/navigation/splash_navigation.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  SplashController(
      {required this.profilesService,
      required this.deepLinkService,
      required this.urlService,
      required this.permissionsService});
  final ProfilesService profilesService;
  final DeepLinkService deepLinkService;
  final UrlService urlService;
  final PermissionsService permissionsService;

  Rx<Profile> activeProfile = Profile().obs;

  late final SplashNavigation navigation;

  late final AnimationController animationController;

  bool animationStarted = false;
  bool _splashClosed = false;
  Timer? _safetyTimer;

  /// Maximum time the splash screen is allowed to stay on screen before we
  /// force-dismiss it. This guards against Lottie failing to load, parse, or
  /// emit a "completed" callback in release builds — without this we observed
  /// the app hanging on the splash screen on TestFlight.
  static const Duration _maxSplashDuration = Duration(seconds: 5);

  @override
  void onInit() {
    navigation = SplashNavigation(
        urlService: urlService, permissionsService: permissionsService);

    animationController = AnimationController(vsync: this)
      ..addStatusListener((status) {
        switch (status) {
          case AnimationStatus.dismissed:
            animationStarted = true;
            break;
          case AnimationStatus.completed:
            closeSplash();
            break;
          case AnimationStatus.forward:
          case AnimationStatus.reverse:
          default:
            break;
        }
      });

    // Hard safety net: even if the Lottie animation never loads or never
    // completes (e.g. an "Infinity or NaN toInt" parsing error in release),
    // we never want the user to be stuck on the splash screen.
    _safetyTimer = Timer(_maxSplashDuration, () {
      if (!_splashClosed) {
        closeSplash();
      }
    });

    super.onInit();
  }

  @override
  void onClose() {
    _safetyTimer?.cancel();
    animationController.dispose();
    super.onClose();
  }

  void closeSplash() {
    if (_splashClosed) return;
    _splashClosed = true;
    _safetyTimer?.cancel();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    Get.backLegacy();
    activeProfile = profilesService.activeProfile;
    final Uri? deepLink = deepLinkService.deepLink();

    if (profilesService.profiles.isEmpty) {
      Future.delayed(1.milliseconds, () {
        navigation.viewWelcome();
      });
    } else if (deepLink != null) {
      final cardId = BearApp.tryExtractCardId(deepLink);
      if (cardId != null) {
        navigation.captureCard(deepLink: BearApp.buildCardUnlockUrl(cardId));
      }
    }
  }
}
