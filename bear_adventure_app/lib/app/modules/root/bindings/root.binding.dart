import 'package:bear_adventure_app/app/modules/root/controllers/root.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:firebase_app_utils/firebase_app_utils.dart';
import 'package:get/get.dart';

class RootBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(() => RootController(
          urlService: Get.find<UrlService>(),
          deepLinkService: Get.find<DeepLinkService>(),
          authService: Get.find<AuthService>(),
          profilesService: Get.find<ProfilesService>())),
    ];
  }
}
