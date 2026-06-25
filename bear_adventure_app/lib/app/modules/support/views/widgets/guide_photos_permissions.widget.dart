import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class GuidePhotosPermissions extends StatelessWidget {
  const GuidePhotosPermissions({super.key, required this.permissionStatus});
  final PermissionStatus permissionStatus;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    String content = LocaleKeys.help_guide_photos_access_disabled_content.tr;

    switch (permissionStatus) {
      case PermissionStatus.granted:
        content = LocaleKeys.help_guide_photos_access_enabled_content.tr;
        break;
      case PermissionStatus.limited:
        content =
            LocaleKeys.help_guide_photos_access_partially_disabled_content.tr;
        break;
      default: // denied, limited, permanentlyDenied
        content = LocaleKeys.help_guide_photos_access_disabled_content.tr;
        break;
    }

    return Center(
        child: Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            runSpacing: 24,
            children: [
          Center(
            child: Text(
              LocaleKeys.help_guide_photos_access_title.tr,
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium,
            ),
          ),
          Center(
              child: SizedBox(
                  height: 150,
                  child: BearAssets.images.global.camera
                      .image(package: BearApp.bearNecessities))),
          Center(
            child: Text(
              content,
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.s22,
            ),
          ),
        ]));
  }
}
