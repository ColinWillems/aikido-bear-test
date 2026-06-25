import 'package:bear_adventure_app/app/modules/cards/controllers/card.controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_app_utils/firebase_app_utils.dart';
import 'package:flutter/material.dart' hide Card, BackButton;
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart' hide GetNumUtils;
import 'package:lottie/lottie.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';

class CardUnlockView extends GetWidget<CardController> {
  const CardUnlockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      CardCollection cardCollection = controller.cardCollection.value;
      CardSet cardSet = controller.cardSet.value;
      Card card = controller.card.value;

      const String baseUrl = "/";

      String unlockImagePath = baseUrl;

      switch (cardCollection.unlockType) {
        case 0:
          unlockImagePath += cardCollection.unlockImagePath;
          break;
        case 1:
          unlockImagePath += cardSet.unlockImagePath;
          break;
        case 2:
          unlockImagePath += card.unlockImagePath;
          break;
      }
      return CircularRevealAnimation(
        animation: controller.animation,
        centerAlignment: Alignment.center,
        child: Scaffold(
          backgroundColor: BearColors.bearGreen,
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                cacheManager: FirebaseCacheManager(),
                imageUrl: unlockImagePath,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const ColoredBox(
                    color: BearColors.bearGreen, child: SizedBox.expand()),
              ),
              Lottie.asset(
                BearAssets.images.cards.unlock.cardUnlocked.path,
                package: BearApp.bearNecessities,
                controller: controller.messageAnimationController,
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animate: true,
                repeat: false,
                onLoaded: (comp) {
                  controller.messageAnimationController.stop();
                  controller.messageAnimationController.duration =
                      comp.duration;
                  controller.showFullScreenDialog();
                },
                errorBuilder: (context, error, stackTrace) {
                  controller.hideFullScreenDialog();
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
