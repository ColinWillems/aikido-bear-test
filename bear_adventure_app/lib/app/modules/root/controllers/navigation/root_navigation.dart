import 'package:bear_adventure_app/app/modules/cards/controllers/card_capture.controller.dart';
import 'package:bear_adventure_app/app/routes/app_pages.dart';
import 'package:bear_adventure_app/app/utils/common.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class RootNavigation {
  RootNavigation({required this.urlService});
  final UrlService urlService;

  void showAppSplashScreen() {
    Common.showFullScreenDialog(Routes.splash, urlService, Routes.splash, true);
  }

  void goToProfiles() {
    Common.showFullScreenDialog(
        Routes.profiles, urlService, "${Routes.settings}${Routes.profiles}");
  }

  void goHome() {
    Common.navigateTo(Routes.home, urlService, Routes.cards,
        parameters: {"tab": "2"});
  }

  void goToTrophyCabinet() {
    Common.navigateTo(Routes.trophyCabinet, urlService, Routes.trophyCabinet);
  }

  void goToSettings() {
    Common.navigateTo(Routes.settings, urlService, Routes.settings);
  }

  void captureCard({String? deepLink}) {
    Common.showFullScreenDialog(
        Routes.captureCard, urlService, "${Routes.cards}${Routes.captureCard}");

    if (deepLink != null) {
      Future.delayed(const Duration(milliseconds: 700), () {
        try {
          final controller = Get.find<CardCaptureController>();
          controller.captureCardFromUrl(deepLink);
        } catch (_) {
          // Controller not found - ignore
        }
      });
    }
  }
}
