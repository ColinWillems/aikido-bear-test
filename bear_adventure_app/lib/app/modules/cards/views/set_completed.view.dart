import 'package:bear_adventure_app/app/modules/cards/controllers/set_completed.controller.dart';
import 'package:flutter/material.dart' hide Card, BackButton;
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart' hide GetNumUtils;
import 'package:lottie/lottie.dart';

/// Full-screen celebration dialog shown when the user has just unlocked
/// every card in a [CardSet].
class SetCompletedView extends GetWidget<SetCompletedController> {
  const SetCompletedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.85),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        // Tap to skip the celebration.
        behavior: HitTestBehavior.opaque,
        onTap: () => controller.messageAnimationController.value = 1.0,
        child: Center(
          child: Lottie.asset(
            BearAssets.images.cards.unlock.setCompleted.path,
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
              // If the animation fails to load, just dismiss.
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
