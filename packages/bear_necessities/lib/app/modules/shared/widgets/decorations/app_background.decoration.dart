import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';

class AppBackground extends BoxDecoration {
  AppBackground({
    super.color,
    DecorationImage? image,
    super.border,
    super.borderRadius,
    super.backgroundBlendMode,
    super.boxShadow,
    super.gradient,
    super.shape,
  }) : super(
            image: image ??
                DecorationImage(
                    fit: BoxFit.fitWidth,
                    repeat: ImageRepeat.repeatY,
                    image: BearAssets.images.global.backgroundTextureGreen
                        .image(
                            package: BearApp.bearNecessities,
                            fit: BoxFit.cover,
                            repeat: ImageRepeat.repeatY)
                        .image));
}
