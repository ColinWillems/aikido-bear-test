import 'dart:async';

import 'package:bear_adventure_app/app/modules/cards/controllers/navigation/cards_navigation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';

/// Controller for the "Set Completed" celebration dialog that is shown
/// after a user unlocks the final card of a [CardSet].
class SetCompletedController extends GetxController
    with GetTickerProviderStateMixin {
  SetCompletedController({
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

  late final AnimationController messageAnimationController =
      AnimationController(vsync: this);

  @override
  void onInit() {
    navigation = CardsNavigation(
      service: service,
      urlService: urlService,
      permissionsService: permissionsService,
    );

    cardCollection = service.selectedCollection;
    cardSet = service.selectedSet;

    messageAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onAnimationComplete();
      }
    });

    super.onInit();
  }

  void _onAnimationComplete() {
    // Close this dialog. If the parent collection was also just unlocked
    // (the service holds a one-shot flag), follow up with the
    // collection-completed celebration.
    Get.close();
    if (service.consumePendingCollectionCompletion()) {
      Timer(300.milliseconds, () {
        navigation.viewCollectionCompletedDialog();
      });
    }
  }

  @override
  void onClose() {
    messageAnimationController.dispose();
    super.onClose();
  }
}
