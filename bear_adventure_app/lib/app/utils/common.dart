import 'package:bear_adventure_app/app/modules/shared/responsive_view_container.widget.dart';
import 'package:bear_adventure_app/app/routes/app_pages.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Common {
  Common._();

  static void navigateTo(
      String route, UrlService urlService, String replacementPath,
      {bool preventDuplicates = false, Map<String, String>? parameters}) {
    urlService.setUrlOverride(
      originalPath: route,
      replacementPath: replacementPath,
    );

    Get.toNamed(route,
        preventDuplicates: preventDuplicates, parameters: parameters);
  }

  static void showFullScreenDialog(
      String route, UrlService urlService, String replacementPath,
      [bool transparentBarrier = false]) {
    GetPage<dynamic>? getPage = AppPages.routes.first.children
        .firstWhereOrNull((page) => page.name == route);

    if (getPage != null) {
      for (var bind in getPage.bindings) {
        bind.dependencies();
      }
      urlService.setUrlOverride(
        originalPath: route,
        replacementPath: replacementPath,
      );

      Get.generalDialog(
        barrierColor:
            transparentBarrier ? Colors.transparent : const Color(0x80000000),
        pageBuilder: (_, __, ___) {
          return ResponsiveViewContainer(
              showBackground: !transparentBarrier, child: getPage.page());
        },
        routeSettings: RouteSettings(name: route),
      );
    }
  }

  static void dismissKeyboard() => Get.focusScope!.unfocus();
}
