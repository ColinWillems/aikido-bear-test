import 'package:bear_adventure_app/app/modules/trophy_cabinet/controllers/reward_part_video.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class RewardPartVideoBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
        () => RewardPartVideoController(
          service: Get.find<TrophyCabinetService>(),
          urlService: Get.find<UrlService>(),
          profilesService: Get.find<ProfilesService>(),
          permissionsService: Get.find<PermissionsService>(),
        ),
      ),
    ];
  }
}
