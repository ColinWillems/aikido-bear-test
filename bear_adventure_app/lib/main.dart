import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:bear_adventure_app/app/services/deferred_deep_link.service.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_app_utils/flutter_app_utils.dart';
import 'package:firebase_app_utils/firebase_app_utils.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:bear_adventure_app/app/routes/app_pages.dart';
import 'package:bear_adventure_app/app/utils/common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'network_logger.dart';

Future<void> main() async {
  HttpOverrides.global = LoggingHttpOverrides();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: BearColors.bearGreen,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: BearColors.bearGreen,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // On Android the native `FirebaseInitProvider` (a ContentProvider) already
  // auto-initialises the default Firebase app from `google-services.json`
  // before `main()` runs, so calling `Firebase.initializeApp` with explicit
  // options throws `[core/duplicate-app]` in release builds. The Dart-side
  // `Firebase.apps` cache is populated lazily so a simple `isEmpty` check
  // isn't enough — we have to catch the duplicate-app error and continue.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  }

  final appLinks = AppLinks();
  final Uri? initialLink = await appLinks.getInitialLink();
  // Default-disable all Firebase data collection until the user has given
  // explicit consent via the analytics consent screen. This MUST run before
  // any other code that could trigger Firebase logging.
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  await FirebasePerformance.instance.setPerformanceCollectionEnabled(false);

  // Initialise the consent service. If the user has already given consent
  // in a previous session, this re-enables Firebase data collection.
  final analyticsConsentService = await AnalyticsConsentService().init();

  runApp(BEARAdventureApp(
    initialLink: initialLink,
    analyticsConsentService: analyticsConsentService,
  ));
}

class BEARAdventureApp extends StatelessWidget {
  const BEARAdventureApp({
    super.key,
    this.initialLink,
    required this.analyticsConsentService,
  });

  void _sendScreenViewToAnalytics(String screenName) {
    if (!analyticsConsentService.consentGiven.value) return;
    final analytics = FirebaseAnalytics.instance;
    analytics.logScreenView(screenName: screenName).catchError(
          (Object error) {},
        );
  }

  final Uri? initialLink;
  final AnalyticsConsentService analyticsConsentService;

  @override
  Widget build(BuildContext context) {
    final UrlService urlService = UrlService();
    return GestureDetector(
      // Dismiss keyboard when clicked outside
      onTap: () => Common.dismissKeyboard(),
      child: GetMaterialApp(
        routingCallback: (Routing? routing) {
          String screenName = routing?.route?.settings.name ?? "/dialog";
          String? urlOverride =
              urlService.getUrlOverride(originalPath: screenName);
          screenName = (urlOverride != null) ? urlOverride : screenName;

          return _sendScreenViewToAnalytics(screenName);
        },
        binds: [
          Bind.put(urlService),
          Bind.put(DeepLinkService(initialLink: initialLink)),
          Bind.put(DeferredDeepLinkService()),
          Bind.put(AuthService()),
          Bind.put(PermissionsService()),
          Bind.put(OnboardingService()),
          Bind.put(ContactService()),
          Bind.put(analyticsConsentService),
          Bind.put(SettingsService()),
          Bind.put(DatabaseService()),
          Bind.put(StorageService()),
          Bind.put(ProfilesRepository()),
          Bind.put(ProfilesService(
              profilesRepository: Get.find<ProfilesRepository>())),
          Bind.put(MockBearRewardRepository<BearReward, BearRewardContext>()),
          Bind.put(MockBearRewardPartRepository<BearRewardPart,
              BearRewardPartContext>()),
          Bind.put(TrophyCabinetService(
              rewardRepository: Get.find<
                  MockBearRewardRepository<BearReward, BearRewardContext>>(),
              rewardPartRepository: Get.find<
                  MockBearRewardPartRepository<BearRewardPart,
                      BearRewardPartContext>>())),
          Bind.put(MockCardCollectionRepository<CardCollection,
              CardCollectionContext>()),
          Bind.put(MockCardRepository<Card, CardContext>()),
          Bind.put(CardsService(
              cardCollectionRepository: Get.find<
                  MockCardCollectionRepository<CardCollection,
                      CardCollectionContext>>(),
              cardRepository:
                  Get.find<MockCardRepository<Card, CardContext>>())),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, // This is required
        ],
        builder: (context, child) => ResponsiveBreakpoints.builder(
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1000, name: 'LARGE_TABLET'),
            const Breakpoint(start: 1001, end: 1200, name: 'SMALL_DESKTOP'),
            const Breakpoint(start: 1201, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
          child: child ?? const SizedBox(),
        ),
        initialRoute: Routes.initial,
        theme: AppThemes.themeData,
        getPages: AppPages.routes,
        locale: Get.deviceLocale!,
        fallbackLocale: const Locale("en", "GB"),
        translationsKeys: AppTranslation.translations,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
