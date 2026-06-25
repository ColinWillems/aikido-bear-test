import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';

class DynamicFeature extends StatelessWidget {
  const DynamicFeature({
    super.key,
    this.alignment = FeatureAlignment.left,
    this.icon,
    this.title,
    this.text,
    this.background,
    this.color = BearColors.bearGreen,
  }) : assert(text != null || title != null);
  final FeatureAlignment alignment;
  final ImageProvider? background;
  final Widget? icon;
  final Widget? title;
  final String? text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final Widget titleLayer = Flexible(
      fit: FlexFit.tight,
      child: (title != null)
          ? title!
          : Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                  left: (alignment == FeatureAlignment.left) ? 15 : 45,
                  right: (alignment == FeatureAlignment.right) ? 15 : 45),
              child: Text(
                text ?? "",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.brownColor,
              ),
            ),
    );

    final List<Widget> rowChildren = [];
    rowChildren.add(titleLayer);
    if (icon != null) {
      if (alignment == FeatureAlignment.left) {
        rowChildren.insert(0, icon!);
      } else {
        rowChildren.add(icon!);
      }
    }
    return Container(
        decoration: FeatureBackground(color: color, radius: 0),
        child: Row(
          children: rowChildren,
        ));
  }
}

enum DynamicFeatureAlignment {
  left,
  right;
}
