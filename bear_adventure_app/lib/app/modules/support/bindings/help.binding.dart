import 'package:bear_adventure_app/app/modules/support/controllers/help.controller.dart';
import 'package:bear_adventure_app/app/services/deferred_deep_link.service.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class HelpBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
        () => HelpController(
          profilesService: Get.find<ProfilesService>(),
          permissionsService: Get.find<PermissionsService>(),
          deepLinkService: Get.find<DeepLinkService>(),
          deferredDeepLinkService: Get.find<DeferredDeepLinkService>(),
          urlService: Get.find<UrlService>(),
        ),
      ),
    ];
  }
}
