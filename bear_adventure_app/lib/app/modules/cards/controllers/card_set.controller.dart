import 'dart:async';

import 'package:bear_adventure_app/app/modules/cards/controllers/navigation/cards_navigation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:introduction_screen/introduction_screen.dart';

class CardSetController extends GetxController {
  CardSetController({
    required this.service,
    required this.urlService,
    required this.permissionsService,
  });

  final CardsService service;
  final UrlService urlService;
  final PermissionsService permissionsService;

  Rx<CardCollection> cardCollection = CardCollection().obs;

  Rx<CardSet> cardSet = CardSet().obs;

  final RxList<Card> cards = <Card>[const Card()].obs;

  late final CardsNavigation navigation;

  final String imageBaseUrl = "/";

  final stepsKey = GlobalKey<IntroductionScreenState>();
  final RxInt currentSetIndex = 0.obs;
  final RxBool isLastSet = false.obs;
  final RxBool isFirstSet = true.obs;

  @override
  void onInit() async {
    navigation = CardsNavigation(
      service: service,
      urlService: urlService,
      permissionsService: permissionsService,
    );

    cardCollection = service.selectedCollection;
    cardSet = service.selectedSet;
    cards.clear();
    // De geselecteerde set kan na snelle navigatie nog van een vorige
    // collection zijn; clamp dan naar de eerste set i.p.v. -1 te gebruiken
    // (wat verderop in onSetChange tot een RangeError zou leiden).
    final int initialIndex = cardCollection().sets.indexOf(cardSet());
    onSetChange(initialIndex < 0 ? 0 : initialIndex);

    super.onInit();
  }

  void selectCardSet(CardSet selectedCardSet) {
    service.selectSet(selectedCardSet);
    cards.clear();
    cards.assignAll(service.getCardsForSet(selectedCardSet));
  }

  void previousSet() {
    stepsKey.currentState?.previous();
  }

  void nextSet() {
    stepsKey.currentState?.next();
  }

  void goToSet(int setIndex) {
    stepsKey.currentState?.animateScroll(setIndex);
  }

  void onSetChange(int newIndex) {
    Timer(const Duration(milliseconds: 500), () {
      // Controller kan tussen scheduling en uitvoering al gesloten zijn,
      // of de collection kan veranderd zijn naar één met minder sets.
      // Beide gevallen defensief afhandelen.
      final List<CardSet> sets = cardCollection().sets;
      if (sets.isEmpty || newIndex < 0 || newIndex >= sets.length) {
        return;
      }
      int numPages = stepsKey.currentState?.getPagesLength() ?? 1;

      currentSetIndex(newIndex);
      goToSet(newIndex);
      isFirstSet(currentSetIndex() == 0);
      isLastSet(currentSetIndex() == (numPages - 1));
      selectCardSet(sets[newIndex]);
    });
  }
}
