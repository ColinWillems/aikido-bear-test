import 'package:firebase_app_utils/firebase_app_utils.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  AuthController();

  @override
  void onReady() async {
    final authService = Get.find<AuthService>();
    await authService.signInAnonymously();
    super.onReady();
  }

  final RxInt counter = 0.obs;
  void increase() async {
    counter.value += 1;
  }

  void decrease() {
    counter.value -= 1;
  }
}
