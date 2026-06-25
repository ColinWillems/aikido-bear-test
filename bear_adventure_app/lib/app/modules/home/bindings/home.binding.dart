import 'package:bear_adventure_app/app/modules/home/controllers/home.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class HomeBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
          () => HomeController(profilesService: Get.find<ProfilesService>())),
    ];
  }
}
