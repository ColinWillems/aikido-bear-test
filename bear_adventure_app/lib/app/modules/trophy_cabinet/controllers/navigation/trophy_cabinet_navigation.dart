import 'dart:async';

import 'package:bear_adventure_app/app/routes/app_pages.dart';
import 'package:bear_adventure_app/app/utils/common.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';

class TrophyCabinetNavigation {
  TrophyCabinetNavigation({required this.service, required this.urlService});
  final TrophyCabinetService service;
  final UrlService urlService;

  void viewHome() {
    Common.navigateTo(
      Routes.home,
      urlService,
      Routes.home,
    );
  }

  void viewTrophyCabinet({bool hack = false}) {
    if (!hack) {
      service.selectedBearReward.value = null;
      clearSelectedState();
    }
    const String targetTab = "1";
    Common.navigateTo(Routes.trophyCabinet, urlService, Routes.trophyCabinet);
  }

  void clearSelectedState() {
    service.selectedBearRewardPart.value = null;
    service.selectedKind.value = null;
  }

  void viewBearReward({BearReward? reward, bool keepState = false}) {
    if (reward == null) {
      reward = service.selectedBearReward();
    } else {
      service.selectBearReward(reward);
    }

    if (reward != null) {
      if (!keepState) {
        clearSelectedState();

        final analytics = FirebaseAnalytics.instance;
        analytics.logEvent(name: "view_bear_reward", parameters: {
          "id": reward.id,
          "title": reward.name,
        });
        analytics.logViewItemList(
          itemListId: reward.id,
          itemListName: reward.name,
        );
      }
      Common.navigateTo(Routes.reward, urlService,
          "${Routes.trophyCabinet}/${_convertIdToUrlPathSegment(reward.id)}");
    }
  }

  Future<void> viewRewardPart(BearRewardPart rewardPart,
      [Function? completionCallback]) async {
    rewardPart =
        await service.selectBearRewardPart(rewardPart, completionCallback);
    if (rewardPart.loaded) {
      final analytics = FirebaseAnalytics.instance;
      analytics.logEvent(name: "view_chapter_part", parameters: {
        "id": rewardPart.id,
        "title": rewardPart.name,
        "category": rewardPart.reward?.name ?? "",
      });
      analytics.logViewItem(items: [
        AnalyticsEventItem(
          itemId: rewardPart.id,
          itemName: rewardPart.name,
          itemCategory: rewardPart.reward?.name,
        )
      ]);
      proceedToChapterPart();
    }
  }

  void closeDialogs() {
    Get.close();
  }

  void proceedToChapterPart() async {
    final BearRewardPart? rewardPart = service.selectedBearRewardPart();
    if (rewardPart != null) {
      switch (rewardPart.kind) {
        case BearRewardPartKind.video:
          closeDialogs();
          Common.navigateTo(Routes.rewardPartVideo, urlService,
              "${Routes.trophyCabinet}${Routes.rewardPartVideo}");
          break;
      }
    }
  }

  void finishRewardPart({bool unlocked = false}) async {
    BearRewardPart? rewardPart = service.selectedBearRewardPart();
    if (rewardPart != null) {
      final BearReward? reward = service.selectedBearReward();
      final bool partNotCompleted = !rewardPart.completed;

      if (partNotCompleted) {
        if (partNotCompleted) {
          rewardPart = await service.completeBearRewardPart(
              rewardPart.id, rewardPart.reward!.id);
        }

        if (rewardPart != null) {
          viewBearReward(keepState: true);
        }
        Future.delayed(700.milliseconds, showRewardPartCompletedReward);
      } else {
        closeDialogs();
        Future.delayed(600.milliseconds, viewBearReward);
      }
    }
  }

  void showRewardPartCompletedReward() {
    final BearRewardPart? rewardPart = service.selectedBearRewardPart();
    if (rewardPart != null) {
      Common.showFullScreenDialog(Routes.rewardOrPartCompleted, urlService,
          "${Routes.trophyCabinet}/${_convertIdToUrlPathSegment(rewardPart.reward?.id)}/${_convertIdToUrlPathSegment(rewardPart.id)}${Routes.rewardOrPartCompleted}");
    }
  }

  void viewPermissions() {
    Common.showFullScreenDialog(Routes.permissions, urlService,
        "${Routes.settings}${Routes.permissions}");
  }

  String _convertIdToUrlPathSegment(String? id) {
    final String pathSegment =
        (id ?? "unknown").replaceAll("_", "-").toLowerCase();
    return pathSegment;
  }
}
