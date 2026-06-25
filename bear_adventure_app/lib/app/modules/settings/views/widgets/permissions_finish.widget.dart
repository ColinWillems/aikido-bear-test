import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionsFinish extends StatelessWidget {
  const PermissionsFinish({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Center(
        child: Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            runSpacing: 24,
            children: [
          Center(
            child: Text(
              LocaleKeys.settings_permissions_finished_title.tr,
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium
                  ?.copyWith(color: const Color(0xFFA32722)),
            ),
          ),
          Center(
            child: Text(
              LocaleKeys.settings_permissions_finished_content.tr,
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.s22,
            ),
          ),
        ]));
  }
}
