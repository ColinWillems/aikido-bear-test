import 'package:flutter/material.dart' hide Card;
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';

class CardShowdownCountdownController extends GetxController
    with GetTickerProviderStateMixin {
  CardShowdownCountdownController({
    required this.service,
  });
  final CardsService service;

  Rx<Card> card = Card().obs;

  late final AnimationController animationController =
      AnimationController(vsync: this);

  @override
  void onInit() async {
    card = service.selectedCard;

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

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
