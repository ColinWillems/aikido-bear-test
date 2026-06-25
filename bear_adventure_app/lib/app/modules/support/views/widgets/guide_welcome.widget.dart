import 'package:bear_adventure_app/app/modules/settings/views/widgets/active_profile.widget.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuideWelcome extends StatelessWidget {
  const GuideWelcome({super.key, this.name = ""});
  final String name;

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
            child: Column(
              children: [
                Text(
                  LocaleKeys.help_guide_hello_title.tr
                      .replaceFirst(RegExp(r'%character_name%'), name),
                  textWidthBasis: TextWidthBasis.parent,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  LocaleKeys.help_guide_hello_subtitle.tr,
                  textWidthBasis: TextWidthBasis.parent,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const Center(child: ActiveProfile(width: 140)),
          Center(
            child: Text(
              LocaleKeys.help_guide_hello_content.tr,
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.s22,
            ),
          ),
        ]));
  }
}
