import 'package:bear_adventure_app/app/modules/support/controllers/navigation/support_navigation.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class SupportController extends GetxController {
  SupportController(
      {required this.urlService, required this.permissionsService});
  final UrlService urlService;
  final PermissionsService permissionsService;

  late final SupportNavigation navigation;

  @override
  Future<void> onInit() async {
    navigation = SupportNavigation(
        urlService: urlService, permissionsService: permissionsService);

    super.onInit();
  }
}
