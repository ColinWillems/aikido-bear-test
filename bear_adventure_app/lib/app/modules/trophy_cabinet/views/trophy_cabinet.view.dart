import 'package:bear_adventure_app/app/modules/trophy_cabinet/controllers/trophy_cabinet.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:get/get.dart' hide GetNumUtils;
import 'package:tinycolor2/tinycolor2.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_app_utils/firebase_app_utils.dart';

class TrophyCabinetView extends GetView<TrophyCabinetController> {
  const TrophyCabinetView({super.key});

  @override
  Widget build(BuildContext context) {
    final double hPadding = AppThemes.appLayout.padding.sm.left;

    final String baseUrl = controller.imageBaseUrl;

    return Obx(() {
      final double maxWidth = AppThemes.appLayout.maxViewWidth;
      final double padding = AppThemes.appLayout.padding.sm.left;

      const double rewardImageHeight = 156;
      return Scaffold(
        backgroundColor: BearColors.bearGreen.lighten(10),
        appBar: AppBar(
          toolbarHeight: rewardImageHeight,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          bottomOpacity: 0,
          backgroundColor: Colors.transparent,
          leading: BackButton(
            onPressed: controller.navigation.viewHome,
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: Container(
                  color: BearColors.bearGreen,
                )),
          ),
          title: MaterialButton(
            padding: const EdgeInsets.all(0),
            onPressed: null,
            child: Container(
              padding: const EdgeInsets.all(0),
              clipBehavior: Clip.antiAlias,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(16)),
              child: BearAssets.images.trophyCabinet.trophyCabinet.image(
                package: BearApp.bearNecessities,
                fit: BoxFit.cover,
                height: rewardImageHeight,
                width: rewardImageHeight * 1.076,
              ),
            ),
          ),
        ),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.02,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          padding: EdgeInsets.only(
              top: 18, left: hPadding, right: hPadding, bottom: 12),
          itemCount: controller.rewards().length,
          itemBuilder: (context, i) {
            BearReward? prevChapter =
                i == 0 ? null : controller.rewards()[i - 1];
            BearReward reward = controller.rewards()[i];
            bool locked = (prevChapter != null && !prevChapter.completed) ||
                reward.locked;
            Color color = BearColors.bearCards;
            CachedNetworkImage image = CachedNetworkImage(
              cacheManager: FirebaseCacheManager(),
              imageUrl: "$baseUrl${reward.imagePath}",
              fit: BoxFit.cover,
            );

            Widget rewardOverlay = (locked)
                ? Positioned(
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
                  )
                : Positioned(
                    bottom: 5,
                    right: 5,
                    width: 20,
                    height: 20,
                    child: BearAssets.images.global.icons.taskCompletionIcon
                        .image(package: BearApp.bearNecessities));
            Widget rewardDisplay = (!reward.completed && !locked)
                ? image
                : Stack(
                    fit: StackFit.passthrough,
                    children: [
                      image,
                      rewardOverlay,
                    ],
                  );
            return PushableButton(
                color: color.tint(20),
                elevation: 6,
                borderRadius: 16,
                onPressed: (() {
                  if (!locked) {
                    controller.navigation.viewBearReward(reward: reward);
                  } else {
                    controller.showLockedMessage(reward: reward);
                  }
                }),
                child: Container(
                  padding: const EdgeInsets.all(0),
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(16)),
                  child: rewardDisplay,
                )).animate(delay: (i * 200).ms).shake(duration: 500.ms, hz: 7);
          },
        ),
      );
    });
  }
}
