import 'package:flutter_app_utils/services/onboarding_service.dart';
import 'package:get/get.dart';

class OnboardingGuard extends GetMiddleware {
  final onboardingService = Get.find<OnboardingService>();

  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    if (!onboardingService.isUserOnboarded.value) {
      final newRoute = onboardingService.onboardingRoute;
      return RouteDecoder.fromRoute(newRoute);
    }
    return await super.redirectDelegate(route);
  }
}
