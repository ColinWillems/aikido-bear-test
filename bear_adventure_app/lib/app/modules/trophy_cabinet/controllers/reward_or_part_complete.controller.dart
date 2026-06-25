import 'package:bear_adventure_app/app/modules/trophy_cabinet/controllers/navigation/trophy_cabinet_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';

class RewardOrPartCompleteController extends GetxController
    with GetTickerProviderStateMixin {
  RewardOrPartCompleteController({
    required this.service,
    required this.urlService,
    required this.profilesService,
    required this.permissionsService,
  });

  final TrophyCabinetService service;
  final UrlService urlService;
  final ProfilesService profilesService;
  final PermissionsService permissionsService;

  late final TrophyCabinetNavigation navigation;
  late final AnimationController animationController =
      AnimationController(vsync: this);

  Rxn<BearReward> reward = Rxn<BearReward>();
  Rxn<BearRewardPart> rewardPart = Rxn<BearRewardPart>();

  @override
  Future<void> onInit() async {
    navigation =
        TrophyCabinetNavigation(service: service, urlService: urlService);
    reward = service.selectedBearReward;
    rewardPart = service.selectedBearRewardPart;

    animationController.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.completed:
          proceedToReward();
          break;
        default:
          break;
      }
    });

    super.onInit();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void proceedToReward() {
    navigation.closeDialogs();
    if (reward() != null) {
      if (reward()!.completed) {
        navigation.viewTrophyCabinet();
      } else {
        navigation.viewBearReward();
      }
    }
  }
}
