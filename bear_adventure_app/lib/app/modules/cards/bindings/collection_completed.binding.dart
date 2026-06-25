import 'package:bear_adventure_app/app/modules/cards/controllers/collection_completed.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class CollectionCompletedBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
        () => CollectionCompletedController(
          service: Get.find<CardsService>(),
          urlService: Get.find<UrlService>(),
          permissionsService: Get.find<PermissionsService>(),
        ),
      ),
    ];
  }
}
