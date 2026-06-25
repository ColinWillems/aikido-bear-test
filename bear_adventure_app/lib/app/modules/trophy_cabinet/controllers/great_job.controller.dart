import 'package:bear_adventure_app/app/modules/trophy_cabinet/controllers/navigation/trophy_cabinet_navigation.dart';
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';

class GreatJobController extends GetxController {
  GreatJobController({required this.service, required this.urlService});

  final TrophyCabinetService service;
  final UrlService urlService;

  final String imageBaseUrl = "/";

  late final TrophyCabinetNavigation navigation;

  @override
  void onInit() {
    navigation =
        TrophyCabinetNavigation(service: service, urlService: urlService);
    super.onInit();
  }
}
