import 'package:bear_adventure_app/app/modules/settings/controllers/profiles.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class ProfilesBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
        () => ProfilesController(
          service: Get.find<ProfilesService>(),
          urlService: Get.find<UrlService>(),
        ),
      ),
    ];
  }
}
