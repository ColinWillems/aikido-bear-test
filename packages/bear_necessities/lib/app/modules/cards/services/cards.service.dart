import 'dart:async';

import 'package:bear_necessities/bear_necessities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_app_utils/utils/cache_manager/firebase/firebase.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:gamification/gamification.dart';
import 'package:get/get.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardsService extends GetxService {
  CardsService({
    required this.cardCollectionRepository,
    required this.cardRepository,
  });

  late Gamification gamification;

  final CardRepository<Card, CardContext> cardRepository;
  final CardCollectionRepository<CardCollection, CardCollectionContext>
  cardCollectionRepository;

  final RxList<CardCollection> cardCollections = <CardCollection>[].obs;

  final RxList<Card> cards = <Card>[].obs;

  final Rx<CardCollection> selectedCollection = CardCollection().obs;
  final Rx<CardSet> selectedSet = CardSet().obs;
  final Rx<Card> selectedCard = Card().obs;

  /// Set when [unlockCard] just completed the parent set of the unlocked
  /// card. The UI consumes this flag to decide whether to show the
  /// "set completed" celebration. Reset via [consumePendingSetCompletion].
  bool _pendingSetCompletion = false;

  /// Set when [unlockCard] just completed the parent collection of the
  /// unlocked card. The UI consumes this flag to decide whether to show
  /// the "collection completed" celebration. Reset via
  /// [consumePendingCollectionCompletion].
  bool _pendingCollectionCompletion = false;

  bool get hasPendingSetCompletion => _pendingSetCompletion;
  bool get hasPendingCollectionCompletion => _pendingCollectionCompletion;

  bool consumePendingSetCompletion() {
    final v = _pendingSetCompletion;
    _pendingSetCompletion = false;
    return v;
  }

  bool consumePendingCollectionCompletion() {
    final v = _pendingCollectionCompletion;
    _pendingCollectionCompletion = false;
    return v;
  }

  bool userDismissedCardCaptureInstructions = false;

  @override
  Future<void> onInit() async {
    cardCollections.assignAll(await cardCollectionRepository.getAll(null));
    cards.assignAll(await cardRepository.getAll(null));

    CardCollection cardScan = CardCollection(
      id: "scan_a_card",
      index: 0,
      color: BearColors.bearCardScan,
      title: "Scan A Card",
    );
    cardCollections.insert(0, cardScan);

    await _initGamification();

    await _performV201Tasks();
    await _performV4015Tasks();

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

  Future<void> _performV201Tasks() async {
    final sharedPrefs = await SharedPreferences.getInstance();

    bool v201TasksDone = sharedPrefs.getBool("v2.0.1TasksDone") ?? false;

    if (!v201TasksDone) {
      FirebaseCacheManager cacheManager = FirebaseCacheManager();

      const List<String> targetCollection = [
        "grrreatest_games",
        "grrreatest_games",
      ];

      const List<String> targetCards = [
        "1SP3E",
        "2DF4L",
        "02Q83",
        "5JFDE",
        "8K82G",
        "50DDE",
        "ST190",
        "X9140",
      ];

      const String baseUrl = "/";

      // Part 1 - Refresh set images
      for (var cardCollection in cardCollections) {
        if (targetCollection.contains(cardCollection.id)) {
          for (var cardSet in cardCollection.sets) {
            await CachedNetworkImage.evictFromCache(
              baseUrl + cardSet.imagePath,
              cacheManager: cacheManager,
            );
          }
        }
      }
      // Part 2 - refresh selected back of card answers
      for (var cardId in targetCards) {
        Card? card = cards.firstWhereOrNull((card) => card.id == cardId);
        if (card != null) {
          await CachedNetworkImage.evictFromCache(
            baseUrl + card.reverseImagePath,
            cacheManager: cacheManager,
          );
        }
      }
      sharedPrefs.setBool("v2.0.1TasksDone", true);
    }
  }

  Future<void> _performV4015Tasks() async {
    final sharedPrefs = await SharedPreferences.getInstance();

    bool tasksDone = sharedPrefs.getBool("v4.0.15TasksDone") ?? false;

    if (!tasksDone) {
      FirebaseCacheManager cacheManager = FirebaseCacheManager();

      const List<String> targetCollection = ["bearilliant_beasts"];

      const List<String> targetCards = ["X765G"];

      const String baseUrl = "/";

      // Part 1 - refresh selected back of card answers
      for (var cardId in targetCards) {
        Card? card = cards.firstWhereOrNull((card) => card.id == cardId);
        if (card != null) {
          await CachedNetworkImage.evictFromCache(
            baseUrl + card.reverseImagePath,
            cacheManager: cacheManager,
          );
        }
      }

      sharedPrefs.setBool("v4.0.15TasksDone", true);
    }
  }

  Future<void> _initGamification() async {
    gamification = Gamification(enablePersistence: true);
    const Type achievementType =
        Achievement<CardAchievementType, CardRewardType>;
    final cardAchievementSerializer =
        Serializer<Achievement<CardAchievementType, CardRewardType>>(
          deserialize: (Object? json) =>
              CardAchievement.achievementFromJson<
                CardAchievementType,
                CardRewardType
              >(json),
          serialize: (dynamic achievement) {
            return (achievement
                    as Achievement<CardAchievementType, CardRewardType>)
                .toJson();
          },
        );

    gamification.persistenceManager.serializers[achievementType.toString()] =
        cardAchievementSerializer;

    _activeProfileSubscription = gamification.activeProfile.listen(
      _onProfileChange,
    );
  }

  String savedProfile = "";

  Future<void> _onProfileChange(String profile) async {
    if (profile != savedProfile) {
      savedProfile = profile;
      await _restoreAchievements();
    }
  }

  Future<void> _restoreAchievements() async {
    // First clear any unlocked cards from any previous profile
    _lockAllCards();

    // Restore the persisted card achievements for the active profile
    await gamification.restore<CardAchievementType, CardRewardType>();

    // Get the list of unlocked cards for the active profile
    List<Achievement<CardAchievementType, CardRewardType>>
    unlockedCardAchievements = gamification
        .getAchievements<CardAchievementType, CardRewardType>()
        .where(
          (achievement) => achievement.type == CardAchievementType.cardUnlocked,
        )
        .toList();

    // Unlock the cards for the active profile
    for (var achievement in unlockedCardAchievements) {
      final parts = achievement.id.split(":");
      final cardId = parts[2];
      try {
        await unlockCard(cardId, true);
      } catch (e) {
        // A previously-unlocked card no longer exists in the current
        // mockdata (typically because we removed an old collection).
        // Don't crash the whole restore for this; just log and skip.
        // The achievement remains in persistence and will become active
        // again if/when the card is re-added.
        Get.log("[CardsService] Skipping restore for unknown card '$cardId': $e");
      }
    }

    List<Achievement<CardAchievementType, CardRewardType>>
    unlockedCardSetAchievements = gamification
        .getAchievements<CardAchievementType, CardRewardType>()
        .where(
          (achievement) =>
              achievement.type == CardAchievementType.cardSetUnlocked,
        )
        .toList();

    List<Achievement<CardAchievementType, CardRewardType>>
    unlockedCardCollectionAchievements = gamification
        .getAchievements<CardAchievementType, CardRewardType>()
        .where(
          (achievement) =>
              achievement.type == CardAchievementType.cardCollectionUnlocked,
        )
        .toList();

    Set<String> achivementCollections = {};
    Set<String> achivementSets = {};

    for (var achievement in unlockedCardAchievements) {
      final parts = achievement.id.split(":");
      final collectionId = parts[0];
      final setId = parts[1];

      achivementCollections.add(collectionId);
      achivementSets.add(setId);
    }

    for (var collectionId in achivementCollections) {
      addCollectionUnlockedAchievement(collectionId);
    }
  }

  void addCollectionUnlockedAchievement(String collectionId) {
    var cardCollection = getCardCollection(collectionId);
    var cardCollectionUnlockedAchievements = gamification
        .getAchievements<CardAchievementType, CardRewardType>()
        .where(
          (achievement) =>
              achievement.type == CardAchievementType.cardCollectionUnlocked &&
              achievement.id == collectionId,
        )
        .toList();

    if (cardCollection != null &&
        cardCollection.unlocked &&
        cardCollectionUnlockedAchievements.isEmpty) {
      gamification.addAchievement<CardAchievementType, CardRewardType>(
        CardAchievement<CardAchievementType, CardRewardType>(
          type: CardAchievementType.cardCollectionUnlocked,
          id: collectionId,
          rewardType: CardRewardType.cardCollectionUnlocked,
          rewardAmount: 1,
          dateTime: DateTime.now(),
        ),
      );

      final analytics = FirebaseAnalytics.instance;
      analytics.logEvent(
        name: "unlock_card_collection",
        parameters: {
          "type": CardAchievementType.cardCollectionUnlocked.name,
          "id": collectionId,
        },
      );
      analytics.logUnlockAchievement(
        id: "${CardAchievementType.cardCollectionUnlocked.name}:$collectionId",
      );
    }
  }

  void _lockAllCards() {
    final List<CardCollection> collections = cardCollections();
    for (var cardCollection in collections) {
      for (var cardSet in cardCollection.sets) {
        cardSet.cards.clear();
      }
    }
  }

  void selectCard(Card card) {
    selectedCard(card);
    selectSet(card.set!);
  }

  void selectSet(CardSet cardSet) {
    selectedSet(cardSet);
    selectCollection(cardSet.collection!);
  }

  void selectCollection(CardCollection cardCollection) {
    selectedCollection(cardCollection);
  }

  CardCollection? getCardCollection(String collectionId) {
    return cardCollections
        .where((collection) => collection.id == collectionId)
        .firstOrNull;
  }

  CardSet? getCardSet(String setId, String collectionId) {
    CardCollection? cardCollection = getCardCollection(collectionId);

    if (cardCollection == null) {
      return null;
    }

    CardSet? cardSet = cardCollection.sets
        .where((set) => set.id == setId)
        .firstOrNull;

    return cardSet;
  }

  List<Card> getCardsForSet(CardSet cardSet) {
    // unlocked cards for this set (added via addCard when scanned)
    List<Card> availableCards = cardSet.cards;
    CardCollection? collection = cardSet.collection;
    int indexType = (collection != null) ? collection.indexType : 0;

    return List.generate(cardSet.numCards, (i) {
      final collIndex = (indexType == 1) ? 1 + i : cardSet.index + i;

      // Return the unlocked card if it exists in this set.
      final Card? unlocked = availableCards.firstWhereOrNull(
        (card) => card.index == collIndex,
      );
      if (unlocked != null) return unlocked;

      // Look up the card in the service catalogue (service.cards) to get
      // id/title metadata for the locked image — but return it as locked
      // (hasFront: false) so it never navigates to the detail view.
      final Card? catalogue = cards.firstWhereOrNull(
        (c) =>
            c.index == collIndex &&
            c.set?.id == cardSet.id &&
            c.set?.collection?.id == cardSet.collection?.id,
      );
      if (catalogue != null) {
        return catalogue.copyWith(set: cardSet, hasFront: false);
      }

      // Fallback: anonymous locked placeholder.
      return Card(index: collIndex, set: cardSet);
    });
  }

  Future<Card?> unlockCard(String cardId, [bool restoring = false]) async {
    Card? storedCard = cards.firstWhereOrNull(
      (element) => element.id == cardId,
    );

    if (storedCard == null) {
      throw ArgumentError(
        "Grrreat, you've found a card that hasn't been added to this version of BEAR's app yet. Please update the app to the latest version and if you see this message again hold on to your card and you will be able to scan it after an upcoming update.",
        "cardId",
      );
    }

    String? setId = storedCard.set?.id;

    if (setId == null) {
      throw ArgumentError(
        "unable to unlock Card. No set found. Please contact us via the Help - Report Issue form.",
        "cardId",
      );
    }

    String? collectionId = storedCard.set!.collection?.id;

    if (collectionId == null) {
      throw ArgumentError(
        "unable to unlock Card. No collection found. Please contact us via the Help - Report Issue form.",
        "cardId",
      );
    }

    final CardSet? cardSet = getCardSet(setId, collectionId);

    if (cardSet == null) {
      throw ArgumentError(
        "Unable to find Card Set: $setId in Collection: $collectionId.",
        "setId",
      );
    }

    final Card? existingCard = cardSet.cards.firstWhereOrNull(
      (card) => card.id == cardId,
    );

    if (existingCard != null) {
      throw FormatException(
        "You have already unlocked the card: ${existingCard.title}",
        existingCard,
      );
    }

    var card = storedCard;

    // Track completion state before/after adding so we can detect whether
    // *this* unlock was the one that completed the set / collection.
    final bool setWasUnlocked = cardSet.unlocked;
    final bool collectionWasUnlocked =
        cardSet.collection?.unlocked ?? false;

    card = cardSet.addCard(card);

    if (!restoring) {
      final bool setIsNowUnlocked = cardSet.unlocked;
      final bool collectionIsNowUnlocked =
          cardSet.collection?.unlocked ?? false;

      if (!setWasUnlocked && setIsNowUnlocked) {
        _pendingSetCompletion = true;
      }
      if (!collectionWasUnlocked && collectionIsNowUnlocked) {
        _pendingCollectionCompletion = true;
      }

      final String collectionAchievementId = card.set!.collection!.id;
      final String setAchievementId =
          "$collectionAchievementId:${card.set!.id}";
      final String cardAchievementId = "$setAchievementId:${card.id}";
      gamification.addAchievement<CardAchievementType, CardRewardType>(
        CardAchievement<CardAchievementType, CardRewardType>(
          type: CardAchievementType.cardUnlocked,
          id: cardAchievementId,
          rewardType: CardRewardType.cardUnlocked,
          rewardAmount: 1,
          dateTime: DateTime.now(),
        ),
      );

      final analytics = FirebaseAnalytics.instance;
      analytics.logEvent(
        name: "unlock_card",
        parameters: {
          "type": CardAchievementType.cardUnlocked.name,
          "id": cardAchievementId,
        },
      );
      analytics.logUnlockAchievement(
        id: "${CardAchievementType.cardUnlocked.name}:$cardAchievementId",
      );
      if (cardSet.unlocked) {
        // check if cardSet exists within unlockedCardSetAchievements
        analytics.logEvent(
          name: "unlock_card_set",
          parameters: {
            "type": CardAchievementType.cardSetUnlocked.name,
            "id": setAchievementId,
          },
        );
        analytics.logUnlockAchievement(
          id: "${CardAchievementType.cardSetUnlocked.name}:$setAchievementId",
        );
      }
      addCollectionUnlockedAchievement(collectionAchievementId);
    }

    return card;
  }
}
