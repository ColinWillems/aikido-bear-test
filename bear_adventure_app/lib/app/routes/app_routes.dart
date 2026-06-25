// ignore_for_file: non_constant_identifier_names

part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  static const initial = _Paths.initial;
  static const home = _Paths.home;
  static const splash = _Paths.splash;

  static const onboarding = _Paths.onboarding;
  static const welcome = _Paths.welcome;

  static const cards = _Paths.cards;
  static const collection = _Paths.collection;
  static const set = _Paths.set;
  static const card = _Paths.card;
  static const showdown = _Paths.showdown;
  static const showdownCountdown = _Paths.showdownCountdown;
  static const full = _Paths.full;
  static const captureCard = _Paths.captureCard;
  static const unlockCard = _Paths.unlockCard;
  static const setCompleted = _Paths.setCompleted;
  static const collectionCompleted = _Paths.collectionCompleted;

  static const trophyCabinet = _Paths.trophyCabinet;
  static const reward = _Paths.reward;
  static const rewardOrPartCompleted = _Paths.rewardOrPartCompleted;
  static const rewardPartVideo = _Paths.rewardPartVideo;
  static const greatJob = _Paths.greatJob;
  static const settings = _Paths.settings;
  static const profiles = _Paths.profiles;
  static const profileName = _Paths.profileName;
  static const profileAvatar = _Paths.profileAvatar;
  static const permissions = _Paths.permissions;

  static const support = _Paths.support;
  static const guide = _Paths.guide;
  static const contact = _Paths.contact;
  static const report = _Paths.report;
  static const privacy = _Paths.privacy;
  static const analyticsConsent = _Paths.analyticsConsent;

  static const login = _Paths.login;
  Routes._();
  static String LOGIN_THEN(String afterSuccessfulLogin) =>
      '$login?then=${Uri.encodeQueryComponent(afterSuccessfulLogin)}';
  static String PROFILE_VIEW(String profileId) => '$profiles/$profileId';
  static String CARD_COLLECTION_VIEW(String collectionId) =>
      "/collections/$collectionId"; //'$cards/$collectionId';
  static String CARD_SET_VIEW(String collectionId, String setId) =>
      "/sets/$setId"; //'$cards/$collectionId/$setId';
  static String CARD_VIEW(String setId, String collectionId, String cardId,
      [bool isFull = false]) {
    //final String fullSegment = (isFull) ? full : "";
    return "/card/$cardId"; //'$cards/$collectionId/$setId/$cardId$fullSegment';
  }
}

abstract class _Paths {
  static const initial = '/';
  static const splash = '/splash'; // Login page
  static const login = '/login'; // Login page
  static const onboarding =
      '/onboarding'; // Intro page (use full screen dialog)
  static const welcome = '/welcome'; // Welcome page
  static const home = '/home'; // Home page

  static const cards = '/cards'; // Cards page
  static const collection = '/collection'; //:collectionId'; // Series page
  static const set = '/set'; //:setId'; // Set page
  static const card = '/card'; //:cardId'; // Card page
  static const full = '/full'; //:cardId'; // Full Card page
  static const showdown = '/showdown'; //:cardId'; // Card page
  static const showdownCountdown =
      '/showdown-countdown'; //:cardId'; // Card page
  static const captureCard = '/capture-card'; //:cardId'; // Capture Card page
  static const unlockCard = '/unlock-card'; //:cardId'; // Capture Card page
  static const setCompleted =
      '/set-completed'; // Set fully unlocked celebration
  static const collectionCompleted =
      '/collection-completed'; // Collection fully unlocked celebration

  static const trophyCabinet = '/trophy-cabinet';
  static const reward = '/reward';
  static const rewardOrPartCompleted = '/reward-or-part-completed';
  static const rewardPartVideo = '/reward-part-video';
  static const greatJob = '/great-job';
  static const settings = '/settings'; // Settings page
  static const profiles = '/profiles'; // Profiles page
  static const profileName = '/profile-name'; //'/:profileId'; // Profile page
  static const profileAvatar =
      '/profile-avatar'; //'/:profileId'; // Profile page
  static const permissions = '/permissions'; // Permissions page

  static const support = '/support'; // Support page
  static const guide = '/guide'; // Guide page (se full screen dialog)
  static const contact = '/contact'; // Contact page
  static const report = '/report-issue'; // Report issue page
  static const privacy = '/privacy-policy'; // Privacy policy page
  static const analyticsConsent =
      '/analytics-consent'; // Analytics consent page
}
