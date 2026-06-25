import 'package:bear_adventure_app/app/modules/cards/controllers/navigation/cards_navigation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';

/// Controller for the "Collection Completed" celebration dialog shown after
/// a user unlocks the final card of a full [CardCollection].
class CollectionCompletedController extends GetxController
    with GetTickerProviderStateMixin {
  CollectionCompletedController({
    required this.service,
    required this.urlService,
    required this.permissionsService,
  });
  final CardsService service;
  final UrlService urlService;
  final PermissionsService permissionsService;

  late final CardsNavigation navigation;

  Rx<CardCollection> cardCollection = CardCollection().obs;

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

    messageAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Get.close();
      }
    });

    super.onInit();
  }

  @override
  void onClose() {
    messageAnimationController.dispose();
    super.onClose();
  }
}
