import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuideInstructions extends StatelessWidget {
  const GuideInstructions({super.key});

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
              LocaleKeys.help_guide_how_to_scan_cards_title.tr,
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium,
            ),
          ),
          Center(
              child: SizedBox(
                  height: 270,
                  child: BearAssets.images.help.guide.scanCard
                      .image(package: BearApp.bearNecessities))),
          Center(
            child: Text(
              LocaleKeys.help_guide_how_to_scan_cards_content.tr,
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.left,
              style: textTheme.bodyLarge?.s20,
            ),
          ),
        ]));
  }
}
