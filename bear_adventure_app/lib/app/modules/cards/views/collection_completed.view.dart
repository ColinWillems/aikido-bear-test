import 'package:bear_adventure_app/app/modules/cards/controllers/collection_completed.controller.dart';
import 'package:flutter/material.dart' hide Card, BackButton;
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart' hide GetNumUtils;
import 'package:lottie/lottie.dart';

/// Full-screen celebration dialog shown when the user has just unlocked
/// every card in a [CardCollection].
class CollectionCompletedView
    extends GetWidget<CollectionCompletedController> {
  const CollectionCompletedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.85),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => controller.messageAnimationController.value = 1.0,
        child: Center(
          child: Lottie.asset(
            BearAssets.images.cards.unlock.collectionCompleted.path,
            package: BearApp.bearNecessities,
            controller: controller.messageAnimationController,
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animate: true,
            repeat: false,
            onLoaded: (comp) {
              controller.messageAnimationController
                ..stop()
                ..duration = comp.duration
                ..forward();
            },
            errorBuilder: (context, error, stackTrace) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.close();
              });
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
