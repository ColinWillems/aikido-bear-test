import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuidePasteboardPermissions extends StatelessWidget {
  const GuidePasteboardPermissions({
    super.key,
    required this.isPermissionChecked,
    this.clipboardContent,
  });
  final bool isPermissionChecked;
  final String? clipboardContent;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String content = isPermissionChecked
        ? LocaleKeys.help_guide_pasteboard_access_enabled_content.tr
        : LocaleKeys.help_guide_pasteboard_access_disabled_content.tr;

    return Center(
        child: Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            runSpacing: 24,
            children: [
          Center(
            child: Text(
              LocaleKeys.help_guide_pasteboard_access_title.tr,
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium,
            ),
          ),
          Center(
              child: SizedBox(
                  height: 300,
                  child: BearAssets.images.help.guide.bearPasteboard
                      .image(package: BearApp.bearNecessities))),
          Center(
            child: Text(
              content,
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.s22,
            ),
          ),
          if (kDebugMode && isPermissionChecked)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Clipboard: "${clipboardContent ?? '<not read yet>'}"',
                  textWidthBasis: TextWidthBasis.parent,
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
        ]));
  }
}
