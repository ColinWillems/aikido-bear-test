import 'dart:async';

import 'package:bear_adventure_app/app/modules/cards/controllers/navigation/cards_navigation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardCollectionController extends GetxController {
  CardCollectionController({
    required this.service,
    required this.urlService,
    required this.permissionsService,
  });
  final CardsService service;
  final UrlService urlService;
  final PermissionsService permissionsService;

  final stepsKey = GlobalKey<IntroductionScreenState>();

  late final StreamSubscription<CardCollectionViewType> _streamSubscription;
  bool _streamSubscriptionInitialized = false;

  late final CardsNavigation navigation;

  final String imageBaseUrl = "/";

  @override
  Future<void> onInit() async {
    navigation = CardsNavigation(
      service: service,
      urlService: urlService,
      permissionsService: permissionsService,
    );
    cardCollection = service.selectedCollection;
    cardSets.addAll(cardCollection().sets);
    cards.clear();
    bool indexByCollection = cardCollection().indexType == 0;
    int currentIndex = 1;
    var resetIndex = false;
    for (var cardSet in cardSets) {
      if (indexByCollection) {
        resetIndex = cardSet.indexType == 1;
        if (resetIndex) {
          currentIndex = cardSet.index;
        }
        if (cardSet.index == 0 && currentIndex != cardSet.index) {
          final int numCardsToAdd = cardSet.index - currentIndex;
          cards.addAll(service.getCardsForSet(CardSet(
              index: currentIndex,
              numCards: numCardsToAdd,
              collection: cardCollection())));
        }
      }
      cards.addAll(service.getCardsForSet(cardSet));
      if (indexByCollection) {
        currentIndex = cardSet.index + cardSet.numCards;
      }
    }
    if (indexByCollection && !resetIndex) {
      final int numCardsToAdd = cardCollection().numCards - (currentIndex - 1);
      if (numCardsToAdd > 0) {
        cards.addAll(service.getCardsForSet(CardSet(
            index: currentIndex,
            numCards: numCardsToAdd,
            collection: cardCollection())));
      }
    }

    final sharedPrefs = await SharedPreferences.getInstance();
    CardCollectionViewType defaultCardCollectionViewType =
        CardCollectionViewType.values.byName(
            sharedPrefs.getString("collectionViewType") ??
                CardCollectionViewType.sets.name);
    _streamSubscription = collectionView.listen((type) {
      sharedPrefs.setString("collectionViewType", type.name);

      stepsKey.currentState
          ?.animateScroll(type == CardCollectionViewType.sets ? 0 : 1);
    });
    _streamSubscriptionInitialized = true;
    collectionView(defaultCardCollectionViewType);

    super.onInit();
  }

  @override
  void onClose() {
    // Wanneer de controller heel snel weer gesloten wordt (gebruiker tikt
    // back voordat de async init voltooid is) is `_streamSubscription` nog
    // niet toegekend. Vermijd een LateInitializationError.
    if (_streamSubscriptionInitialized) {
      _streamSubscription.cancel();
    }
  }

  Rx<CardCollection> cardCollection = CardCollection().obs;

  final RxList<CardSet> cardSets = <CardSet>[].obs;

  final RxList<Card> cards = <Card>[].obs;

  final Rx<CardCollectionViewType> collectionView =
      CardCollectionViewType.sets.obs;
}
