import 'package:bear_adventure_app/app/modules/cards/controllers/card_showdown_countdown.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class CardShowdownCountdownBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
        () => CardShowdownCountdownController(
          service: Get.find<CardsService>(),
        ),
      ),
    ];
  }
}
