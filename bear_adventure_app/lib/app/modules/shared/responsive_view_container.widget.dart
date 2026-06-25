import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:get/get.dart';

class ResponsiveViewContainer extends StatelessWidget {
  const ResponsiveViewContainer(
      {super.key, required this.child, this.showBackground = true});

  final Widget child;
  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    final scaleFactors = AppThemes.appLayout.scaleFactors;

    return MaxWidthBox(
      maxWidth: 2400,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: showBackground ? null : BearColors.bearGreen,
        decoration: showBackground
            ? BoxDecoration(
                color: BearColors.bearGreen,
                image: DecorationImage(
                    image: BearAssets.images.global.backgroundTextureGreyscale
                        .image(
                          color: BearColors.bearGreen,
                          repeat: ImageRepeat.repeatY,
                          fit: BoxFit.fitWidth,
                          package: "bear_necessities",
                        )
                        .image))
            : null,
        child: ResponsiveScaledBox(
          width: ResponsiveValue<double>(context,
              defaultValue: context.width / scaleFactors['default']!,
              conditionalValues: [
                Condition.equals(
                    name: MOBILE, value: context.width / scaleFactors[MOBILE]!),
                Condition.equals(
                    name: TABLET, value: context.width / scaleFactors[TABLET]!),
                Condition.equals(
                    name: 'LARGE_TABLET',
                    value: context.width / scaleFactors['LARGE_TABLET']!),
                Condition.equals(
                    name: 'SMALL_DESKTOP',
                    value: context.width / scaleFactors['SMALL_DESKTOP']!),
                Condition.equals(
                    name: DESKTOP,
                    value: context.width / scaleFactors[DESKTOP]!),
                Condition.equals(
                    name: '4K', value: context.width / scaleFactors['4K']!),
                // There are no conditions for width over 1200
                // because the `maxWidth` is set to 1200 via the MaxWidthBox.
              ]).value,
          child: child,
        ),
      ),
    );
  }
}
