import 'package:bear_adventure_app/app/modules/trophy_cabinet/controllers/reward_or_part_complete.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart' hide GetNumUtils;
import 'package:tinycolor2/tinycolor2.dart';

class RewardOrPartCompleteView
    extends GetWidget<RewardOrPartCompleteController> {
  const RewardOrPartCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final BearRewardPart? rewardPart = controller.rewardPart();
      BearReward? reward = controller.reward();
      final AnimationController animationController =
          controller.animationController;

      final String completedTitle = (reward != null && reward.completed
          ? reward.name
          : rewardPart?.name ?? "");
      final String message = "Completed!";
      return Scaffold(
          backgroundColor: BearColors.bearCards.lighten(40),
          body: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 8, right: 12, left: 12, bottom: 130),
              child: SafeArea(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                    Text(completedTitle,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.brownColor),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Stack(
                        fit: StackFit.loose,
                        children: [
                          BearAssets.images.dialogs.activityCompletedAnimation
                              .lottie(
                                  controller: animationController,
                                  alignment: Alignment.center,
                                  fit: BoxFit.contain,
                                  animate: true,
                                  repeat: false,
                                  onLoaded: (comp) {
                                    animationController.reset();
                                    animationController
                                      ..duration = comp.duration
                                      ..forward();
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    controller.proceedToReward();
                                    return const SizedBox.expand();
                                  },
                                  package: BearApp.bearNecessities),
                          Center(
                              child: Text(message,
                                      style: textTheme
                                          .displayMedium!.brownColor.s32.w900)
                                  .animate()
                                  .scale(
                                      duration: 2.seconds,
                                      curve: Curves.bounceInOut)),
                        ],
                      ),
                    ),
                  ]))));
    });
  }
}
