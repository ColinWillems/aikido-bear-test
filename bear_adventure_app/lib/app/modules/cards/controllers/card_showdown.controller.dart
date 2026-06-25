import 'dart:async';
import 'dart:math';

import 'package:bear_adventure_app/app/modules/cards/controllers/navigation/cards_navigation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';

class CardShowdownController extends GetxController
    with GetTickerProviderStateMixin {
  CardShowdownController({
    required this.service,
    required this.urlService,
    required this.permissionsService,
  });
  final CardsService service;
  final UrlService urlService;
  final PermissionsService permissionsService;

  late final CardsNavigation navigation;

  Rx<CardCollection> cardCollection = CardCollection().obs;

  Rx<CardSet> cardSet = CardSet().obs;

  Rx<Card> card = Card().obs;

  final RxList<Card> opponents = <Card>[const Card()].obs;

  Rx<Card> opponentCard = Card().obs;

  Rx<CardSet> opponentSet = CardSet().obs;

  Rx<Card> winningCard = Card().obs;

  RxBool showResult = false.obs;

  static const String winningSet = "super_hero";

  final String imageBaseUrl = "/";

  late final AnimationController animationController =
      AnimationController(vsync: this);

  @override
  void onInit() async {
    navigation = CardsNavigation(
      service: service,
      urlService: urlService,
      permissionsService: permissionsService,
    );

    cardCollection = service.selectedCollection;
    cardSet = service.selectedSet;
    card = service.selectedCard;
    opponents.clear();
    for (var otherSet in cardCollection().sets) {
      if (otherSet.id != cardSet().id) {
        opponentSet(otherSet);
        if (otherSet.cards.isNotEmpty) {
          opponents.addAll(otherSet.cards);
        }
      }
    }
    selectRandomOpponent();

    animationController.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.completed:
          hideCountdown();
          break;
        default:
          break;
      }
    });

    super.onInit();
  }

  void hideCountdown() {
    Get.close();
  }

  void selectOpponent(Card opponent) {
    opponentCard(opponent);
  }

  void selectRandomOpponent() {
    if (opponents.isNotEmpty) {
      opponentCard(opponents[Random().nextInt(opponents.length)]);
    }
  }

  void showdown() {
    navigation.viewCardShowdownCountdown();
    Timer(3.seconds, () {
      if (card().set != null && card().set!.id == winningSet) {
        winningCard(card());
      } else {
        winningCard(opponentCard());
      }

      showResult(true);
    });
  }

  void returnToShowdown() {
    selectRandomOpponent();
    showResult(false);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
