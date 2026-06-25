import 'package:bear_adventure_app/app/modules/splash/controllers/splash.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class SplashBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
        () => SplashController(
          profilesService: Get.find<ProfilesService>(),
          deepLinkService: Get.find<DeepLinkService>(),
          urlService: Get.find<UrlService>(),
          permissionsService: Get.find<PermissionsService>(),
        ),
      ),
    ];
  }
}
