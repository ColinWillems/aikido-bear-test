import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar(
      {super.key,
      this.width,
      this.color = Colors.black,
      this.decorations = const [],
      this.name = "",
      this.displayName = false,
      this.active = false});
  final double? width;
  final List<ProfileDecoration> decorations;
  final Color color;
  final String name;
  final bool displayName;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return FittedBox(
        alignment: Alignment.center,
        fit: BoxFit.contain,
        clipBehavior: Clip.none,
        child: Container(
            clipBehavior: Clip.none,
            width: width,
            height: width,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double strokeWidth = constraints.maxHeight * 0.07;
                final Color strokeColor = BearColors.creamWhite;
                // Beer image vult de volledige cirkel tot tegen de witte rand.
                // Kleine overlap (50% van de stroke) zodat er geen pixel-gap zichtbaar is;
                // ClipOval snijdt het overschot weg.
                final double bearInset = strokeWidth * 0.75;
                final double bearSize = constraints.maxHeight - (bearInset * 2);
                final List<Positioned> decorationLayers =
                    decorations.map<Positioned>(
                  (decoration) {
                    double? x = decoration.xPosition != null
                        ? constraints.maxWidth * (decoration.xPosition ?? 0)
                        : null;
                    double? y = decoration.yPosition != null
                        ? constraints.maxHeight * (decoration.yPosition ?? 0)
                        : null;
                    double? width = decoration.width != null
                        ? constraints.maxWidth * (decoration.width ?? 0)
                        : null;
                    double? height = decoration.height != null
                        ? constraints.maxHeight * (decoration.height ?? 0)
                        : null;
                    return Positioned(
                      left: x,
                      top: y,
                      width: width,
                      height: height,
                      child: decoration.toImage(),
                    );
                  },
                ).toList();
                final Widget backgroundLayer = Container(
                  clipBehavior: Clip.none,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      border: Border.all(
                          color: strokeColor,
                          strokeAlign: BorderSide.strokeAlignInside,
                          width: strokeWidth),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(5, 5),
                            spreadRadius: 0,
                            blurRadius: 4,
                            blurStyle: BlurStyle.normal)
                      ]),
                );
                final Widget bearLayer = BearAssets
                    .images.settings.profile.avatarBear
                    .image(package: BearApp.bearNecessities, fit: BoxFit.cover);
                final List<Positioned> persistentLayers = [
                  Positioned(
                      left: 0,
                      width: constraints.maxWidth,
                      top: 0,
                      height: constraints.maxHeight,
                      child: backgroundLayer),
                  Positioned(
                      left: bearInset,
                      width: bearSize,
                      top: bearInset * 0.5,
                      height: bearSize + bearInset,
                      child: ClipOval(child: bearLayer)),
                ];
                final Positioned nameLabelLayer = Positioned(
                    left: 0,
                    top: 0,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: Align(
                      alignment: const Alignment(0, 0.6),
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: textTheme.displaySmall!.w900.s24.copyWith(
                          shadows: [
                            Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10)
                          ],
                        ),
                      ),
                    )
                        .animate(
                            delay: 500.ms,
                            onPlay: (controller) =>
                                controller.repeat(reverse: true))
                        .fadeOut(
                            delay: 2.seconds,
                            duration: 2.seconds,
                            curve: Curves.easeInOut)
                        .then(delay: 3.seconds));
                final List<Positioned> avatarLayers = persistentLayers.toList();
                avatarLayers.addAll(decorationLayers);
                if (displayName) {
                  avatarLayers.add(nameLabelLayer);
                }
                return Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: avatarLayers
                        .animate(interval: 250.ms)
                        .scaleXY(duration: 250.ms, curve: Curves.bounceOut));
              },
            )));
  }
}
