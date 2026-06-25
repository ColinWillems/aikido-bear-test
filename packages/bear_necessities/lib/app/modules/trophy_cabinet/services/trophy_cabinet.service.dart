import 'dart:async';

import 'package:bear_necessities/bear_necessities.dart';
import 'package:gamification/gamification.dart';
import 'package:get/get.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class TrophyCabinetService extends GetxService {
  TrophyCabinetService(
      {required this.rewardRepository, required this.rewardPartRepository});

  final BearRewardRepository<BearReward, BearRewardContext> rewardRepository;
  final BearRewardPartRepository<BearRewardPart, BearRewardPartContext>
      rewardPartRepository;

  late Gamification gamification;

  final RxList<BearReward> _rewards = <BearReward>[].obs;

  final Rxn<BearRewardPart> selectedBearRewardPart = Rxn<BearRewardPart>();
  final Rxn<BearReward> selectedBearReward = Rxn<BearReward>();
  final Rxn<BearRewardPartKind> selectedKind =
      Rxn<BearRewardPartKind>(BearRewardPartKind.video);

  Function? completionCallback;

  @override
  Future<void> onInit() async {
    _rewards.assignAll(await rewardRepository.getAll(null));

    await _initGamification();

    super.onInit();
  }

  @override
  Future<void> onClose() async {
    if (_activeProfileSubscription != null) {
      _activeProfileSubscription!.cancel();
    }

    super.onClose();
  }

  StreamSubscription<String>? _activeProfileSubscription;

  Future<void> _initGamification() async {
    gamification = Gamification(enablePersistence: true);
    const Type achievementType =
        Achievement<TrophyCabinetAchievementType, TrophyCabinetRewardType>;
    final trophyCabinetAchievementSerializer = Serializer<
        Achievement<TrophyCabinetAchievementType, TrophyCabinetRewardType>>(
      deserialize: (Object? json) =>
          TrophyCabinetAchievement.achievementFromJson<
              TrophyCabinetAchievementType, TrophyCabinetRewardType>(json),
      serialize: (dynamic achievement) {
        return (achievement as Achievement<TrophyCabinetAchievementType,
                TrophyCabinetRewardType>)
            .toJson();
      },
    );

    gamification.persistenceManager.serializers[achievementType.toString()] =
        trophyCabinetAchievementSerializer;

    _activeProfileSubscription =
        gamification.activeProfile.listen(_onProfileChange);
  }

  String savedProfile = "";

  void _onProfileChange(String profile) {
    if (profile != savedProfile) {
      savedProfile = profile;
      _restoreAchievements();
    }
  }

  Future<void> _restoreAchievements() async {
    // First clear any completed parts from any previous profile
    _resetAllRewardsStatuses();

    // Restore the persisted card achievements for the active profile
    await gamification
        .restore<TrophyCabinetAchievementType, TrophyCabinetRewardType>();

    // Get the list of unlocked Reward Parts for the active profile
    List<Achievement<TrophyCabinetAchievementType, TrophyCabinetRewardType>>
        completedBearRewardParts = gamification
            .getAchievements<TrophyCabinetAchievementType,
                TrophyCabinetRewardType>()
            .where((achievement) =>
                achievement.type ==
                TrophyCabinetAchievementType.rewardPartCompleted)
            .toList();

    // Complete the parts for the active profile
    for (var achievement in completedBearRewardParts) {
      final parts = achievement.id.split(":");
      final rewardId = parts[0];
      final rewardPartId = parts[1];

      await completeBearRewardPart(rewardPartId, rewardId, true);
    }
  }

  void _resetAllRewardsStatuses() {
    for (int i = _rewards.length - 1; i > -1; i--) {
      BearReward reward = _rewards[i];
      reward.resetAllBearRewardPartStatuses();
    }
  }

  Future<BearRewardPart> selectBearRewardPart(BearRewardPart rewardPart,
      [Function? completionCallback]) async {
    this.completionCallback = completionCallback;
    // If rewardPart hasn't been loaded, load it from repository first
    if (!rewardPart.loaded) {
      rewardPart =
          await getBearRewardPart(rewardPart.id, rewardPart.reward!.id) ??
              rewardPart;
    }
    selectedBearRewardPart.value = rewardPart;
    selectedKind.value = rewardPart.kind;
    selectBearReward(rewardPart.reward!);
    return rewardPart;
  }

  void selectBearReward(BearReward reward) {
    selectedBearReward(reward);
  }

  Future<BearRewardPart?> completeBearRewardPart(
      String rewardPartId, String rewardId,
      [bool restoring = false]) async {
    BearRewardPart? rewardPart =
        await getBearRewardPart(rewardPartId, rewardId);
    if (rewardPart != null) {
      final BearReward? reward = rewardPart.reward;
      if (reward != null) {
        rewardPart = reward.setBearRewardPartStatus(rewardPart, true);
      }
      if (!restoring) {
        final String rewardAchievementId = rewardPart.reward!.id;
        final String rewardPartAchievementId =
            "$rewardAchievementId:${rewardPart.id}";
        gamification.addAchievement<TrophyCabinetAchievementType,
            TrophyCabinetRewardType>(TrophyCabinetAchievement<
                TrophyCabinetAchievementType, TrophyCabinetRewardType>(
            type: TrophyCabinetAchievementType.rewardPartCompleted,
            id: rewardPartAchievementId,
            rewardType: TrophyCabinetRewardType.rewardPartCompleted,
            rewardAmount: 1,
            dateTime: DateTime.now()));
        final analytics = FirebaseAnalytics.instance;
        analytics.logEvent(
            name: TrophyCabinet.rewardPartCompletedAnalyticsName,
            parameters: {
              "type": TrophyCabinetAchievementType.rewardPartCompleted.name,
              "id": rewardPartAchievementId
            });
        analytics.logUnlockAchievement(
            id: "${TrophyCabinetAchievementType.rewardPartCompleted.name}:$rewardPartAchievementId");

        if (reward != null) {
          if (reward.completed) {
            analytics.logEvent(
                name: TrophyCabinet.rewardCompletedAnalyticsName,
                parameters: {
                  "type": TrophyCabinetAchievementType.rewardCompleted.name,
                  "id": rewardAchievementId
                });

            analytics.logUnlockAchievement(
                id: "${TrophyCabinetAchievementType.rewardCompleted.name}:$rewardAchievementId");
          }
        }
        if (completionCallback != null) {
          completionCallback!();
        }
      }
      return rewardPart;
    }
    return null;
  }

  bool hasCompletedCardCollection(String id) {
    final List<Achievement<CardAchievementType, CardRewardType>>
        bearilliantBeastsCollectionUnlockedAchievements = gamification
            .getAchievements<CardAchievementType, CardRewardType>()
            .where(
              (achievement) =>
                  achievement.type ==
                      CardAchievementType.cardCollectionUnlocked &&
                  achievement.id == id,
            )
            .toList();
    return bearilliantBeastsCollectionUnlockedAchievements.isNotEmpty;
  }

  List<BearReward> getAchievedRewards() {
    final List<BearReward> achievedRewards = <BearReward>[];
    for (var reward in _rewards) {
      if (reward.kind == BearRewardKind.cardCollection &&
          hasCompletedCardCollection(reward.id)) {
        achievedRewards.add(reward);
      }
    }
    return achievedRewards;
  }

  BearReward? getBearReward(String rewardId) {
    return _rewards.where((reward) => reward.id == rewardId).firstOrNull;
  }

  List<BearRewardPart> getPartsForBearReward(BearReward reward) {
    List<BearRewardPart> parts = reward.parts;

    return parts;
  }

  Future<BearRewardPart?> getBearRewardPart(
      String rewardPartId, String rewardId) async {
    BearReward? reward = getBearReward(rewardId);

    if (reward == null) {
      return null;
    }

    final BearRewardPart? existingBearRewardPart = reward.parts
        .firstWhereOrNull((rewardPart) => rewardPart.id == rewardPartId);

    if (existingBearRewardPart != null && existingBearRewardPart.loaded) {
      return existingBearRewardPart;
    }

    var rewardPart = await rewardPartRepository.get(
        rewardPartId, BearRewardPartContext(reward.id));

    if (rewardPart != null) {
      rewardPart = reward.addBearRewardPart(rewardPart);
    }

    return rewardPart;
  }
}
