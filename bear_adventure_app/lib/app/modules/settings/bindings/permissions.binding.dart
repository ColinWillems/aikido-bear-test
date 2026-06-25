import 'package:bear_adventure_app/app/modules/settings/controllers/permissions.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class PermissionsBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
          () => PermissionsController(
              service: Get.find<PermissionsService>(),
              profilesService: Get.find<ProfilesService>())),
    ];
  }
}
