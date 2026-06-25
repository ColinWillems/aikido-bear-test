import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';

class TabLabel extends StatelessWidget {
  const TabLabel(
      {super.key,
      this.text = "",
      this.backgroundColor = BearColors.creamWhite,
      this.textStyle = const TextStyle(color: BearColors.bearAvatarYellow),
      this.width});
  final String text;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final double minWidth = width ?? 110;
    return Center(
      child: Container(
        constraints: BoxConstraints(minWidth: minWidth),
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: BearAssets.images.global.labelBackground
                  .image(
                      package: BearApp.bearNecessities,
                      centerSlice: const Rect.fromLTRB(20, 3, 20, 3))
                  .image),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8, bottom: 3, left: 15, right: 15),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium!.merge(textStyle),
          ),
        ),
      ),
    );
  }
}
