import 'package:bear_adventure_app/app/routes/app_pages.dart';
import 'package:bear_adventure_app/app/utils/common.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter_app_utils/flutter_app_utils.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  OnboardingController({this.onboardingService, required this.urlService});
  final OnboardingService? onboardingService;
  final UrlService urlService;

  void viewPrivacyPolicy() {
    Common.showFullScreenDialog(
        Routes.privacy, urlService, "${Routes.support}${Routes.privacy}");
  }
}
