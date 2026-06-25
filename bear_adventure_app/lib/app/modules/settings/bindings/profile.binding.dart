import 'package:bear_adventure_app/app/modules/settings/controllers/profile.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class ProfileBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
        () => ProfileController(
          service: Get.find<ProfilesService>(),
          urlService: Get.find<UrlService>(),
        ),
      ),
    ];
  }
}
