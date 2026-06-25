import 'package:bear_adventure_app/app/modules/trophy_cabinet/controllers/navigation/trophy_cabinet_navigation.dart';
import 'package:bear_adventure_app/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';

class TrophyCabinetController extends GetxController {
  TrophyCabinetController({required this.service, required this.urlService});

  final TrophyCabinetService service;
  final UrlService urlService;

  late final RxList<BearReward> rewards;

  final String imageBaseUrl = "/";

  late final TrophyCabinetNavigation navigation;

  @override
  void onInit() {
    navigation =
        TrophyCabinetNavigation(service: service, urlService: urlService);
    rewards = service.getAchievedRewards().obs;
    super.onInit();
  }

  void showLockedMessage({required BearReward reward}) {
    Dialogs.showDialog(
        message: "Complete the previous reward to be able to access this one.",
        title: "${reward.name} is locked",
        path: "${Routes.trophyCabinet}/reward-locked");
  }
}
