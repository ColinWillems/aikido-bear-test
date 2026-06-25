import 'dart:async';

import 'package:bear_adventure_app/app/modules/cards/controllers/navigation/cards_navigation.dart';
import 'package:gamification/gamification.dart';
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';

class CardsController extends GetxController {
  CardsController({
    required this.service,
    required this.urlService,
    required this.permissionsService,
  });

  final CardsService service;
  final UrlService urlService;
  final PermissionsService permissionsService;

  late final RxList<CardCollection> cardCollections;

  final RxString collectedCards = "000".obs;

  late final Gamification gamification;
  late final StreamSubscription<num> _streamSubscription;
  late final CardsNavigation navigation;
  final String imageBaseUrl = "/";

  @override
  void onInit() {
    navigation = CardsNavigation(
      service: service,
      urlService: urlService,
      permissionsService: permissionsService,
    );

    cardCollections = service.cardCollections;

    gamification = service.gamification;
    _streamSubscription = gamification
        .getRewardsTotal(CardRewardType.cardUnlocked)
        .listen((numCards) {
      collectedCards((numCards as int).toString().padLeft(3, "0"));
    });

    super.onInit();
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
  }
}
