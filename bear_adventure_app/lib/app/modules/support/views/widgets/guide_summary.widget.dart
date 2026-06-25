import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuideSummary extends StatelessWidget {
  const GuideSummary({super.key});

  /// Kleuren voor de feature items op de "your collection begins here" pagina.
  /// De volgorde bepaalt welk item welke kleur krijgt; index 3 is gereserveerd
  /// voor een eventueel 4de item.
  static const List<Color> _featureColors = [
    Color(0xFF86B0EF), // 1. blauw
    Color(0xFFA56DC3), // 2. paars
    Color(0xFFEA85C9), // 3. roze
    Color(0xFFF4BC42), // 4. geel/oranje (toekomstige extra)
  ];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    const double featureWidth = 300;
    return Center(
        child: Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            runSpacing: 24,
            children: [
          Center(
            child: Text(
              LocaleKeys.help_guide_adventure_begins_title.tr,
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium,
            ),
          ),
          Center(
              child: Wrap(runSpacing: 12, children: [
            SizedBox(
                width: featureWidth,
                child: Feature(
                    alignment: FeatureAlignment.left,
                    color: _featureColors[0],
                    text: LocaleKeys
                        .help_guide_adventure_begins_content_item1.tr,
                    icon: SizedBox(
                        width: 80,
                        height: 62,
                        child: BearAssets.images.help.guide.bearCard.image(
                          package: BearApp.bearNecessities,
                        )))),
            SizedBox(
                width: featureWidth,
                child: Feature(
                    alignment: FeatureAlignment.right,
                    color: _featureColors[1],
                    text: LocaleKeys
                        .help_guide_adventure_begins_content_item2.tr,
                    icon: SizedBox(
                        width: 80,
                        height: 62,
                        child: BearAssets.images.help.guide.scanIt.image(
                          package: BearApp.bearNecessities,
                        )))),
            SizedBox(
                width: featureWidth,
                child: Feature(
                    alignment: FeatureAlignment.left,
                    color: _featureColors[2],
                    text: LocaleKeys
                        .help_guide_adventure_begins_content_item3.tr,
                    icon: SizedBox(
                        width: 80,
                        height: 62,
                        child: BearAssets.images.help.guide.buildCollections
                            .image(
                          package: BearApp.bearNecessities,
                        )))),
            SizedBox(
                width: featureWidth,
                child: Feature(
                    alignment: FeatureAlignment.right,
                    color: _featureColors[3],
                    text: LocaleKeys
                        .help_guide_adventure_begins_content_item4.tr,
                    icon: SizedBox(
                        width: 80,
                        height: 62,
                        child: BearAssets.images.help.guide.more.image(
                          package: BearApp.bearNecessities,
                        )))),
          ])),
        ]));
  }
}
