import 'dart:ui';

import 'package:bear_adventure_app/app/modules/cards/controllers/card_showdown_countdown.controller.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart' hide Card, BackButton;
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart' hide GetNumUtils;
import 'package:lottie/lottie.dart';

class CardShowdownCountdownView
    extends GetWidget<CardShowdownCountdownController> {
  const CardShowdownCountdownView({super.key});

  @override
  Widget build(BuildContext context) {
    final FlutterView window = View.of(context);
    final double displayHeight =
        window.display.size.height / window.devicePixelRatio;
    final double displayWidth =
        window.display.size.width / window.devicePixelRatio;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: DotLottieLoader.fromAsset(
        BearAssets
            .images.cards.showdown.superScienceSquadShowdownResult.keyName,
        package: BearApp.bearNecessities,
        frameBuilder: (ctx, dotlottie) {
          if (dotlottie != null) {
            return OverflowBox(
              minHeight: displayHeight,
              maxHeight: displayHeight,
              maxWidth: double.infinity,
              minWidth: displayWidth,
              alignment: Alignment.center,
              child: UnconstrainedBox(
                child: Lottie.memory(
                  dotlottie.animations.values.single,
                  imageProviderFactory: (asset) {
                    return MemoryImage(dotlottie.images[asset.fileName]!);
                  },
                  controller: controller.animationController,
                  alignment: Alignment.center,
                  fit: BoxFit.fitHeight,
                  height: displayHeight,
                  animate: true,
                  repeat: false,
                  onLoaded: (comp) {
                    controller.animationController.stop();
                    controller.animationController.duration = comp.duration;
                    controller.animationController.forward();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    controller.hideCountdown();
                    return const SizedBox.shrink();
                  },
                ),
              ),
            );
          } else {
            return Container();
          }
        },
        errorBuilder: (context, error, stackTrace) {
          controller.hideCountdown();
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
