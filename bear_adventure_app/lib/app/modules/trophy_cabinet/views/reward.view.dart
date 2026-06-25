import 'package:bear_adventure_app/app/modules/trophy_cabinet/controllers/reward.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_app_utils/firebase_app_utils.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:get/get.dart' hide GetNumUtils;
import 'package:tinycolor2/tinycolor2.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RewardView extends GetView<RewardController> {
  const RewardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final double maxWidth = AppThemes.appLayout.maxViewWidth;
      final double padding = AppThemes.appLayout.padding.sm.left;

      const double rewardImageHeight = 156;
      final BearReward? reward = controller.reward.value;
      final List<BearRewardPart> rewardParts = controller.rewardParts.value;
      final String baseUrl = controller.imageBaseUrl;
      final String rewardImageUrl = (reward != null &&
              reward.id.isNotEmpty &&
              reward.imagePath.isNotEmpty)
          ? "$baseUrl${reward.imagePath}"
          : "";
      return Scaffold(
          backgroundColor: BearColors.bearCards.lighten(40),
          appBar: AppBar(
            toolbarHeight: rewardImageHeight,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            leading: BackButton(onPressed: () {
              controller.navigation.viewTrophyCabinet();
            }),
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Container(
                    color: TinyColor.fromString('25328A').toColor(),
                  )),
            ),
            title: MaterialButton(
              padding: const EdgeInsets.all(0),
              onPressed: (() {
                controller.navigation.viewBearReward();
              }),
              child: Container(
                padding: const EdgeInsets.all(0),
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(16)),
                child: CachedNetworkImage(
                  cacheManager: FirebaseCacheManager(),
                  imageUrl: rewardImageUrl,
                  fit: BoxFit.cover,
                  height: rewardImageHeight,
                  width: rewardImageHeight * 1.076,
                ),
              ),
            ),
          ),
          body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.02,
              mainAxisSpacing: 18,
              crossAxisSpacing: 18,
            ),
            padding: EdgeInsets.only(
                top: 22, left: padding, right: padding, bottom: 120),
            itemCount: rewardParts.length,
            itemBuilder: (context, i) {
              BearRewardPart? prevRewardPart =
                  i == 0 ? null : rewardParts[i - 1];
              BearRewardPart rewardPart = rewardParts[i];
              bool locked = prevRewardPart != null && !prevRewardPart.completed;
              Color color = BearColors.bearCards;
              final String activityImageUrl =
                  (rewardPart.id.isNotEmpty && rewardPart.imagePath.isNotEmpty)
                      ? "$baseUrl${rewardPart.imagePath}"
                      : "";
              CachedNetworkImage image = CachedNetworkImage(
                cacheManager: FirebaseCacheManager(),
                imageUrl: activityImageUrl,
                fit: BoxFit.cover,
              );
              Widget chapterOverlay = Positioned(
                bottom: 0,
                right: 0,
                top: 0,
                left: 0,
                child: Container(
                    alignment: Alignment.center,
                    color: Colors.black.withOpacity(0.4),
                    child: BearAssets.images.global.padlock.image(
                        package: BearApp.bearNecessities,
                        height: 72,
                        width: 96)),
              );
              Widget chapterPartDisplay = (!locked)
                  ? image
                  : Stack(
                      fit: StackFit.passthrough,
                      children: [
                        image,
                        chapterOverlay,
                      ],
                    );

              return PushableButton(
                      color: color.tint(20),
                      elevation: 6,
                      borderRadius: 16,
                      onPressed: (() {
                        if (!locked) {
                          controller.navigation.viewRewardPart(rewardPart);
                        } else {
                          controller.showLockedMessage(rewardPart);
                        }
                      }),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: chapterPartDisplay))
                  .animate(delay: (i * 200).ms)
                  .fade()
                  .shake(duration: 300.ms, hz: 8);
            },
          ));
    });
  }
}
