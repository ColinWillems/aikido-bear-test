import 'package:firebase_app_utils/routes/app_routes.dart';
import 'package:firebase_app_utils/services/auth_service.dart';
import 'package:get/get.dart';

class AuthGuard extends GetMiddleware {
  final authService = Get.find<AuthService>();

  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    if (!authService.isUserAuthenticated.value) {
      const newRoute = AppRoutes.login;
      return RouteDecoder.fromRoute(newRoute);
    }
    return await super.redirectDelegate(route);
  }
}
