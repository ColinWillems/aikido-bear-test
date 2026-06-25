import 'package:bear_adventure_app/app/modules/onboarding/controllers/onboarding.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class OnboardingBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
          () => OnboardingController(urlService: Get.find<UrlService>())),
    ];
  }
}
