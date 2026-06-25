import 'package:flutter/material.dart';
import 'package:bear_necessities/bear_necessities.dart';

class SetProgressBar extends StatelessWidget {
  const SetProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.color,
    this.backgroundColor,
  });
  final String imageBaseUrl = "/";
  final int current;
  final int total;

  /// Foreground colour of the filled portion of the progress bar.
  /// Defaults to [BearColors.bearStandardButton.shade100].
  final Color? color;

  /// Background colour of the empty portion of the progress bar.
  /// Defaults to [BearColors.bearStandardButton.shade900].
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(builder: (context, constraints) {
      final double progressRatio = current / total;
      final double progressValue = 1 * progressRatio;
      final double valueIndicatorWidth = constraints.maxWidth * 0.1;
      final double progressBarHeight = valueIndicatorWidth * 0.8;
      final double valuePosition =
          (constraints.maxWidth * progressRatio) - (valueIndicatorWidth / 2);
      return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                color: color ?? BearColors.bearStandardButton.shade100,
                backgroundColor:
                    backgroundColor ?? BearColors.bearStandardButton.shade900,
                value: progressValue,
                minHeight: progressBarHeight,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
            ),
            Positioned(
              left: valuePosition,
              child: BearAssets.images.global.icons.bearCard.image(
                package: BearApp.bearNecessities,
                width: valueIndicatorWidth,
              ),
            ),
          ]);
    });
  }
}
