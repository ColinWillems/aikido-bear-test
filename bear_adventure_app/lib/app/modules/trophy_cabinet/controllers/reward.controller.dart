import 'dart:async';

import 'package:bear_adventure_app/app/modules/trophy_cabinet/controllers/navigation/trophy_cabinet_navigation.dart';
import 'package:bear_adventure_app/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';

class RewardController extends GetxController {
  RewardController({required this.service, required this.urlService});
  final TrophyCabinetService service;
  final UrlService urlService;

  final String imageBaseUrl = "/";
  late final TrophyCabinetNavigation navigation;

  Rxn<BearReward> reward = Rxn<BearReward>();
  final RxList<BearRewardPart> rewardParts = <BearRewardPart>[].obs;

  late final StreamSubscription<BearRewardPart?>
      _selectedBearRewardPartStreamSubscription;

  @override
  void onInit() async {
    navigation =
        TrophyCabinetNavigation(service: service, urlService: urlService);

    reward = service.selectedBearReward;

    _buildBearRewardParts();

    _selectedBearRewardPartStreamSubscription =
        service.selectedBearRewardPart.listen(onSelectedBearRewardPartChange);

    super.onInit();
  }

  void _buildBearRewardParts() {
    if (reward() != null) {
      rewardParts.assignAll(service.getPartsForBearReward(reward()!));
    }
  }

  @override
  void onClose() {
    _selectedBearRewardPartStreamSubscription.cancel();

    super.onClose();
  }

  void onSelectedBearRewardPartChange(BearRewardPart? rewardPart) {
    _buildBearRewardParts();
  }

  void showLockedMessage(BearRewardPart rewardPart) {
    Dialogs.showDialog(
        message:
            "Complete the previous parts of the reward first to access this",
        title: "This part is locked",
        path: "${Routes.trophyCabinet}/reward-part-locked");
  }
}
