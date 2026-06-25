import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

class AppStandardButton extends StatelessWidget {
  const AppStandardButton(
      {super.key,
      required this.text,
      this.color = BearColors.creamWhite,
      this.onPressed});

  final String text;

  final Color color;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle buttonTextStyle = textTheme.labelMedium!.button;

    // Use explicit colors for our two main button styles:
    // - cream background -> brown text
    // - bear green background -> cream text
    // - orange primary (#F47C66) -> white text
    // - settings green (#84BC51) -> white text
    if (color == BearColors.bearGreen) {
      buttonTextStyle = buttonTextStyle.whiteColor;
    } else if (color == BearColors.creamWhite) {
      buttonTextStyle = buttonTextStyle.brownColor;
    } else if (color.value == 0xFFF47C66) {
      buttonTextStyle = buttonTextStyle.whiteColor;
    } else if (color.value == 0xFF84BC51) {
      buttonTextStyle = buttonTextStyle.whiteColor;
    } else {
      // Fallback to dark/light logic for any other colors
      if (color.isDark) {
        buttonTextStyle = buttonTextStyle.whiteColor;
      } else {
        buttonTextStyle = buttonTextStyle.brownColor;
      }
    }
    return RoundedRectanglePushableButton(
      color: color,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Center(
          child: Text(text.toLowerCase(),
              textAlign: TextAlign.center, style: buttonTextStyle),
        ),
      ),
    );
  }
}
