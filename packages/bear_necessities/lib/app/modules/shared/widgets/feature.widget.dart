import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';

class Feature extends StatelessWidget {
  const Feature(
      {super.key,
      this.alignment = FeatureAlignment.left,
      this.icon,
      this.title,
      this.text,
      this.background,
      this.color})
      : assert(text != null || title != null);
  final FeatureAlignment alignment;
  final ImageProvider? background;
  final Color? color;
  final Widget? icon;
  final Widget? title;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final Widget textWidget = (title != null)
        ? title!
        : Text(
            text ?? "",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          );

    final Widget contentRow = IntrinsicHeight(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Tekst altijd gecentreerd over de volledige breedte; bepaalt de hoogte
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
            child: Align(
              alignment: Alignment.center,
              child: textWidget,
            ),
          ),
          // Icoontje links of rechts gepositioneerd
          if (icon != null)
            Positioned(
              left: (alignment == FeatureAlignment.left) ? 0 : null,
              right: (alignment == FeatureAlignment.right) ? 0 : null,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.center,
                child: icon!,
              ),
            ),
        ],
      ),
    );

    final ImageProvider backgroundImage = background ??
        BearAssets.images.help.guide.summaryItemBackground
            .image(
                package: BearApp.bearNecessities,
                centerSlice: const Rect.fromLTRB(20, 3, 20, 3))
            .image;

    // Harde slagschaduw onder de feature: zelfde vorm als de PNG, verschoven
    // naar rechts-onder. Werkt zowel met PNG-achtergrond als met een gekleurde
    // variant.
    final Widget shadowLayer = Positioned.fill(
      child: Transform.translate(
        offset: const Offset(0, 6),
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(
              Color(0xFF4C692E), BlendMode.srcIn),
          child: Image(
            image: backgroundImage,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );

    if (color != null) {
      // Kleur de achtergrond-PNG met de opgegeven kleur, zodat de originele
      // vorm (inclusief afgeronde hoeken / "tail") behouden blijft.
      return Stack(
        clipBehavior: Clip.none,
        children: [
          shadowLayer,
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
              child: Image(
                image: backgroundImage,
                fit: BoxFit.fill,
              ),
            ),
          ),
          contentRow,
        ],
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        shadowLayer,
        Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: backgroundImage,
              ),
            ),
            child: contentRow),
      ],
    );
  }
}

enum FeatureAlignment {
  left,
  right;
}
