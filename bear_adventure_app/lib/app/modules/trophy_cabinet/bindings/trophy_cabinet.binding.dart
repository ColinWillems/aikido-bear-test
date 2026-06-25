import 'package:bear_adventure_app/app/modules/trophy_cabinet/controllers/trophy_cabinet.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class TrophyCabinetBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
        () => TrophyCabinetController(
          service: Get.find<TrophyCabinetService>(),
          urlService: Get.find<UrlService>(),
        ),
      ),
    ];
  }
}
