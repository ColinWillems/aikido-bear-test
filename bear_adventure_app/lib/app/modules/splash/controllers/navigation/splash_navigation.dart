import 'package:bear_adventure_app/app/modules/cards/controllers/card_capture.controller.dart';
import 'package:bear_adventure_app/app/routes/app_pages.dart';
import 'package:bear_adventure_app/app/utils/common.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashNavigation {
  SplashNavigation(
      {required this.urlService, required this.permissionsService});
  final UrlService urlService;
  final PermissionsService permissionsService;

  void viewWelcome() {
    Common.showFullScreenDialog(Routes.welcome, urlService, Routes.welcome);
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
}
