import 'package:bear_adventure_app/app/modules/trophy_cabinet/controllers/reward.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class RewardBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
        () => RewardController(
          service: Get.find<TrophyCabinetService>(),
          urlService: Get.find<UrlService>(),
        ),
      ),
    ];
  }
}
