import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuideFinish extends StatelessWidget {
  const GuideFinish({super.key});

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
              LocaleKeys.help_guide_finished_title.tr,
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium,
            ),
          ),
          Center(
            child: Text(
              LocaleKeys.help_guide_finished_content.tr,
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.s22,
            ),
          ),
        ]));
  }
}
