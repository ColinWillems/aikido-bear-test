import 'dart:async';

import 'package:bear_adventure_app/app/modules/root/controllers/navigation/root_navigation.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_utils/firebase_app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide GetNumUtils;
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootController extends GetxController {
  RootController(
      {required this.urlService,
      required this.deepLinkService,
      required this.authService,
      required this.profilesService});
  final UrlService urlService;
  final DeepLinkService deepLinkService;
  final AuthService authService;
  final ProfilesService profilesService;
  late final RootNavigation navigation;

  StreamSubscription<Uri?>? _deepLinkSubscription;

  @override
  void onReady() {
    navigation.showAppSplashScreen();
    Future.delayed(300.milliseconds, () {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: BearColors.bearGreen,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: BearColors.bearGreen,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
      FlutterNativeSplash.remove();
    });
    super.onReady();
  }

  @override
  Future<void> onInit() async {
    navigation = RootNavigation(urlService: urlService);
    _deepLinkSubscription = deepLinkService.deepLink.listen(onDeepLink);

    final sharedPrefs = await SharedPreferences.getInstance();

    bool signedIn = await authService.signInAnonymously();

    bool firstRun = sharedPrefs.getBool("firstRun") ?? true;
    final analytics = FirebaseAnalytics.instance;

    if (firstRun) {
      sharedPrefs.setBool("firstRun", false);
      analytics.logEvent(name: "first_view");
    }

    if (signedIn) {
      bool firstLogin = sharedPrefs.getBool("firstLogin") ?? true;
      if (firstLogin) {
        sharedPrefs.setBool("firstLogin", false);
        analytics.logSignUp(signUpMethod: "anonymous");
      }
      analytics.logLogin(loginMethod: "anonymous");
    } else {}

    super.onInit();
  }

  @override
  void onClose() {
    if (_deepLinkSubscription != null) {
      _deepLinkSubscription!.cancel();
    }
    super.onClose();
  }

  void onDeepLink(Uri? deepLink) {
    if (deepLink == null) return;
    final cardId = BearApp.tryExtractCardId(deepLink);
    if (cardId != null && profilesService.profiles.isNotEmpty) {
      navigation.captureCard(deepLink: BearApp.buildCardUnlockUrl(cardId));
      return;
    }
    // Legacy path-segment fallback voor /cards/... routes (niet voor card unlock)
    final path = deepLink.pathSegments;
    if (path.length > 1 && path[0] == Cards.rootPath && profilesService.profiles.isNotEmpty) {
      navigation.captureCard(deepLink: deepLink.toString());
    }
  }

  void sendScreenViewToAnalytics(String screenName) {
    String? urlOverride = urlService.getUrlOverride(originalPath: screenName);
    screenName = (urlOverride != null) ? urlOverride : screenName;

    final analytics = FirebaseAnalytics.instance;
    analytics.setCurrentScreen(screenName: screenName).catchError(
          (Object error) {},
        );
  }
}
