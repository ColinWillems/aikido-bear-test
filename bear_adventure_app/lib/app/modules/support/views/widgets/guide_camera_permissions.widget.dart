import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class GuideCameraPermissions extends StatelessWidget {
  const GuideCameraPermissions({super.key, required this.permissionStatus});
  final PermissionStatus permissionStatus;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String content = (permissionStatus.isGranted)
        ? LocaleKeys.help_guide_camera_access_enabled_content.tr
        : LocaleKeys.help_guide_camera_access_disabled_content.tr;

    return Center(
        child: Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            runSpacing: 24,
            children: [
          Center(
            child: Text(
              LocaleKeys.help_guide_camera_access_title.tr,
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium,
            ),
          ),
          Center(
              child: SizedBox(
                  height: 300,
                  child: BearAssets.images.help.guide.bearCamera
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
