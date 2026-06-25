import 'dart:async';
import 'dart:developer' as developer;

import 'package:bear_adventure_app/app/modules/cards/controllers/navigation/cards_navigation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';

class CardController extends GetxController with GetTickerProviderStateMixin {
  CardController({
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

  final String imageBaseUrl = "/";

  late final AnimationController messageAnimationController =
      AnimationController(vsync: this);
  late final AnimationController animationController =
      AnimationController(vsync: this, duration: 1000.milliseconds);

  late final Animation<double> animation = CurvedAnimation(
    parent: animationController,
    curve: Curves.easeInBack,
    reverseCurve: Curves.easeOutBack,
  );

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

    messageAnimationController.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.completed:
          hideFullScreenDialog();
          break;
        default:
          break;
      }
    });

    super.onInit();
  }

  void showFullscreenInstructions() {
    Dialogs.showSnackbar(
        message: LocaleKeys.cards_info_card_view_instructions.tr);
  }

  void showFullScreenDialog() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: BearColors.bearGreen,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: BearColors.bearGreen,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    animationController.forward();
    // ignore: dead_code
    Timer(1.seconds, () {
      messageAnimationController.forward();
    });
  }

  void hideFullScreenDialog() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    navigation.viewCard(card(), false);
    animationController.reverse();
    Timer(3.seconds, () {
      proceedToCard();
    });
  }

  void proceedToCard() {
    Get.close();
    Timer(4.seconds, () {
      maybeShowCompletionDialog();
    });
  }

  /// After viewing the freshly unlocked card, show the appropriate
  /// celebration dialog:
  ///   * Set fully unlocked  -> set-completed lottie
  ///     (the set-completed controller will chain into the collection-
  ///     completed dialog when applicable; it consumes the collection
  ///     flag itself)
  ///   * Collection fully unlocked (without set completion) ->
  ///     collection-completed lottie
  ///   * Special-case "bearilliant_beasts" -> legacy great-job dialog
  ///
  /// Reads one-shot flags set by [CardsService.unlockCard] so the dialog
  /// is only shown the very first time a set/collection is completed.
  void maybeShowCompletionDialog() {
    final collection = cardCollection();
    final set = cardSet();
    // Peek (do not consume yet) so we can correctly hand off to the
    // set-completed dialog without losing the collection flag.
    final pendingSet = service.hasPendingSetCompletion;
    final pendingCollection = service.hasPendingCollectionCompletion;

    final msg = "[CardController] maybeShowCompletionDialog "
        "collection=${collection.id} (unlocked=${collection.unlocked}, "
        "pending=$pendingCollection) "
        "set=${set.id} (unlocked=${set.unlocked}, pending=$pendingSet, "
        "cards=${set.cards.length}/${set.numCards})";
    Get.log(msg);
    developer.log(msg, name: "CardController");

    // Legacy hook for the Bearilliant Beasts collection.
    if (collection.id == "bearilliant_beasts" && collection.unlocked) {
      // Consume both flags so they don't trigger another dialog later.
      service.consumePendingSetCompletion();
      service.consumePendingCollectionCompletion();
      navigation.viewGreatJobDialog();
      return;
    }

    if (pendingSet) {
      service.consumePendingSetCompletion();
      // The set-completed controller will chain into the collection-
      // completed dialog if the pending-collection flag is still set.
      navigation.viewSetCompletedDialog();
    } else if (pendingCollection) {
      service.consumePendingCollectionCompletion();
      navigation.viewCollectionCompletedDialog();
    }
  }

  /// Backwards-compatible alias.
  void maybeShowCollectionUnlockedDialog() => maybeShowCompletionDialog();

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
