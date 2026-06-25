import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  User? user;
  final RxBool isUserAuthenticated = false.obs;

  Future<bool> signInAnonymously() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      user = userCredential.user;
      isUserAuthenticated(true);
      return user != null;
    } catch (error) {
      isUserAuthenticated(false);
      return false;
    }
  }

  Future<Map<String, dynamic>?> getCustomClaimsForUser() async {
    IdTokenResult? idTokenResult = await user?.getIdTokenResult(true);
    return idTokenResult?.claims;
  }

  Future<bool> isUserAdmin() async {
    final claims = await getCustomClaimsForUser();
    return claims != null && claims['admin'] == true;
  }

  bool isUserAnonymous() {
    return user != null && user!.isAnonymous;
  }
}
