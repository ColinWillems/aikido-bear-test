import 'package:bear_adventure_app/app/modules/support/controllers/analytics_consent.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class AnalyticsConsentBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut(
        () => AnalyticsConsentController(
          analyticsConsentService: Get.find<AnalyticsConsentService>(),
          profilesService: Get.find<ProfilesService>(),
          urlService: Get.find<UrlService>(),
          permissionsService: Get.find<PermissionsService>(),
        ),
      ),
    ];
  }
}
