import 'package:bear_adventure_app/app/modules/cards/controllers/card_capture.controller.dart';
import 'package:bear_adventure_app/app/routes/app_pages.dart';
import 'package:bear_adventure_app/app/utils/common.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SupportNavigation {
  SupportNavigation(
      {required this.urlService, required this.permissionsService});
  final UrlService urlService;
  final PermissionsService permissionsService;

  void contact() {
    Common.showFullScreenDialog(
        Routes.contact, urlService, "${Routes.support}${Routes.contact}");
  }

  void reportBug() {
    Common.showFullScreenDialog(
        Routes.report, urlService, "${Routes.support}${Routes.report}");
  }

  void viewPrivacyPolicy() {
    Common.showFullScreenDialog(
        Routes.privacy, urlService, "${Routes.support}${Routes.privacy}");
  }

  void viewAnalyticsConsent() {
    Common.showFullScreenDialog(Routes.analyticsConsent, urlService,
        "${Routes.support}${Routes.analyticsConsent}");
  }

  void viewGuide() {
    Common.showFullScreenDialog(
        Routes.guide, urlService, "${Routes.support}${Routes.guide}");
  }

  void viewPermissions() {
    Common.showFullScreenDialog(Routes.permissions, urlService,
        "${Routes.settings}${Routes.permissions}");
  }

  Future<void> captureCard({String? deepLink}) async {
    if (permissionsService.cameraPermission().isGranted) {
      Common.showFullScreenDialog(Routes.captureCard, urlService,
          "${Routes.cards}${Routes.captureCard}", true);

      if (deepLink != null) {
        // Give the controller time to initialize, then trigger capture
        Future.delayed(const Duration(milliseconds: 700), () {
          try {
            final controller = Get.find<CardCaptureController>();
            controller.captureCardFromUrl(deepLink);
          } catch (_) {
            // Controller not found - ignore
          }
        });
      }
    } else {
      viewPermissions();
    }
  }

  void editProfile() {
    Common.showFullScreenDialog(Routes.profileName, urlService,
        "${Routes.settings}${Routes.profiles}${Routes.profileName}");
  }

  void goHome() {
    Common.navigateTo(Routes.home, urlService, Routes.cards,
        parameters: {"tab": "2"});
  }
}
