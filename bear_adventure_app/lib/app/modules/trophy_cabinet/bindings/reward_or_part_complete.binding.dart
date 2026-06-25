import 'package:bear_adventure_app/app/modules/trophy_cabinet/controllers/reward_or_part_complete.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class RewardOrPartCompleteBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
        () => RewardOrPartCompleteController(
          service: Get.find<TrophyCabinetService>(),
          urlService: Get.find<UrlService>(),
          profilesService: Get.find<ProfilesService>(),
          permissionsService: Get.find<PermissionsService>(),
        ),
      ),
    ];
  }
}
