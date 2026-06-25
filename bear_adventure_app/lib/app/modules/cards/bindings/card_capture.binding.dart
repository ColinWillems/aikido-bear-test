import 'package:bear_adventure_app/app/modules/cards/controllers/card_capture.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class CardCaptureBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
        () => CardCaptureController(
          service: Get.find<CardsService>(),
          urlService: Get.find<UrlService>(),
          permissionsService: Get.find<PermissionsService>(),
        ),
      ),
    ];
  }
}
