import 'package:get/get.dart';

class OnboardingService extends GetxService {
  final String onboardingRoute = "/onboarding/welcome";
  final String completionRoute = "/home";
  final RxBool isUserOnboarded = false.obs;
  final Set<String> steps = <String>{};

  Future<OnboardingService> init() async {
    return this;
  }
}
