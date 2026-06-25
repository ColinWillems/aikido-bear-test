import 'package:bear_adventure_app/app/modules/trophy_cabinet/controllers/reward_part_video.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_app_utils/firebase_app_utils.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart' hide GetNumUtils;
import 'package:tinycolor2/tinycolor2.dart';

class RewardPartVideoView extends GetWidget<RewardPartVideoController> {
  const RewardPartVideoView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double padding = AppThemes.appLayout.padding.sm.left;

    return Obx(() {
      final BearRewardPart? rewardPart = controller.rewardPart();
      BearReward? reward = controller.reward();
      final String baseUrl = controller.imageBaseUrl;

      return Scaffold(
        extendBody: true,
        backgroundColor: BearColors.bearCards.lighten(20),
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          leading: const BackButton(),
          actions: const [
            SizedBox(width: 54),
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(
              top: 8, right: padding + 18, left: padding + 18, bottom: 0),
          child: Column(
            children: [
              Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: CachedNetworkImage(
                        cacheManager: FirebaseCacheManager(),
                        imageUrl: "$baseUrl${rewardPart?.secondaryImagePath}",
                        fit: BoxFit.contain,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: AppStandardButton(
                              text: "Watch again",
                              onPressed: () => controller.launchVideo(),
                              color: BearColors.bearActionButton,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: AppStandardButton(
                              text: "Complete",
                              onPressed: () =>
                                  controller.navigation.finishRewardPart(),
                              color: BearColors.bearActionButton,
                            ),
                          ),
                        ),
                      ].animate(interval: 200.ms).shake(
                            duration: 300.ms,
                            hz: 7,
                          ),
                    ),
                  ]),
            ],
          ),
        ),
      );
    });
  }
}
