import 'package:bear_adventure_app/app/modules/trophy_cabinet/controllers/great_job.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class GreatJobBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
        () => GreatJobController(
          service: Get.find<TrophyCabinetService>(),
          urlService: Get.find<UrlService>(),
        ),
      ),
    ];
  }
}
