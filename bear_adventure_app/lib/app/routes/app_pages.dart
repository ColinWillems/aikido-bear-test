import 'package:bear_adventure_app/app/modules/cards/bindings/card.binding.dart';
import 'package:bear_adventure_app/app/modules/cards/bindings/card_capture.binding.dart';
import 'package:bear_adventure_app/app/modules/cards/bindings/card_unlock.binding.dart';
import 'package:bear_adventure_app/app/modules/cards/bindings/cards.binding.dart';
import 'package:bear_adventure_app/app/modules/cards/bindings/card_showdown.binding.dart';
import 'package:bear_adventure_app/app/modules/cards/bindings/card_showdown_countdown.binding.dart';
import 'package:bear_adventure_app/app/modules/cards/bindings/card_collection.binding.dart';
import 'package:bear_adventure_app/app/modules/cards/bindings/card_set.binding.dart';
import 'package:bear_adventure_app/app/modules/cards/bindings/collection_completed.binding.dart';
import 'package:bear_adventure_app/app/modules/cards/bindings/set_completed.binding.dart';
import 'package:bear_adventure_app/app/modules/cards/views/card_capture.view.dart';
import 'package:bear_adventure_app/app/modules/cards/views/card_full.view.dart';
import 'package:bear_adventure_app/app/modules/cards/views/card.view.dart';
import 'package:bear_adventure_app/app/modules/cards/views/card_showdown.view.dart';
import 'package:bear_adventure_app/app/modules/cards/views/card_showdown_countdown.view.dart';
import 'package:bear_adventure_app/app/modules/cards/views/card_unlock.view.dart';
import 'package:bear_adventure_app/app/modules/cards/views/cards.view.dart';
import 'package:bear_adventure_app/app/modules/cards/views/card_collection.view.dart';
import 'package:bear_adventure_app/app/modules/cards/views/card_set.view.dart';
import 'package:bear_adventure_app/app/modules/cards/views/collection_completed.view.dart';
import 'package:bear_adventure_app/app/modules/cards/views/set_completed.view.dart';
import 'package:bear_adventure_app/app/modules/home/bindings/home.binding.dart';
import 'package:bear_adventure_app/app/modules/onboarding/bindings/onboarding.binding.dart';
import 'package:bear_adventure_app/app/modules/onboarding/views/welcome.view.dart';
import 'package:bear_adventure_app/app/modules/settings/bindings/permissions.binding.dart';
import 'package:bear_adventure_app/app/modules/settings/bindings/profile.binding.dart';
import 'package:bear_adventure_app/app/modules/settings/bindings/profiles.binding.dart';
import 'package:bear_adventure_app/app/modules/root/bindings/root.binding.dart';
import 'package:bear_adventure_app/app/modules/root/views/root.view.dart';
import 'package:bear_adventure_app/app/modules/settings/bindings/settings.binding.dart';
import 'package:bear_adventure_app/app/modules/settings/views/permissions.view.dart';
import 'package:bear_adventure_app/app/modules/settings/views/profile_avatar.view.dart';
import 'package:bear_adventure_app/app/modules/settings/views/profile_name.view.dart';
import 'package:bear_adventure_app/app/modules/settings/views/profiles.view.dart';
import 'package:bear_adventure_app/app/modules/settings/views/settings.view.dart';
import 'package:bear_adventure_app/app/modules/splash/bindings/splash.binding.dart';
import 'package:bear_adventure_app/app/modules/splash/views/splash.view.dart';
import 'package:bear_adventure_app/app/modules/support/bindings/contact.binding.dart';
import 'package:bear_adventure_app/app/modules/support/bindings/help.binding.dart';
import 'package:bear_adventure_app/app/modules/support/bindings/privacy_policy.binding.dart';
import 'package:bear_adventure_app/app/modules/support/bindings/analytics_consent.binding.dart';
import 'package:bear_adventure_app/app/modules/support/bindings/report_issue.binding.dart';
import 'package:bear_adventure_app/app/modules/support/bindings/support.binding.dart';
import 'package:bear_adventure_app/app/modules/support/views/contact.view.dart';
import 'package:bear_adventure_app/app/modules/support/views/help.view.dart';
import 'package:bear_adventure_app/app/modules/support/views/privacy_policy.view.dart';
import 'package:bear_adventure_app/app/modules/support/views/analytics_consent.view.dart';
import 'package:bear_adventure_app/app/modules/support/views/report_issue.view.dart';
import 'package:bear_adventure_app/app/modules/support/views/support.view.dart';
import 'package:bear_adventure_app/app/modules/trophy_cabinet/bindings/great_job.binding.dart';
import 'package:bear_adventure_app/app/modules/trophy_cabinet/bindings/reward.binding.dart';
import 'package:bear_adventure_app/app/modules/trophy_cabinet/bindings/reward_or_part_complete.binding.dart';
import 'package:bear_adventure_app/app/modules/trophy_cabinet/bindings/reward_part_video.binding.dart';
import 'package:bear_adventure_app/app/modules/trophy_cabinet/bindings/trophy_cabinet.binding.dart';
import 'package:bear_adventure_app/app/modules/trophy_cabinet/views/great_job.view.dart';
import 'package:bear_adventure_app/app/modules/trophy_cabinet/views/reward.view.dart';
import 'package:bear_adventure_app/app/modules/trophy_cabinet/views/reward_part_complete.view.dart';
import 'package:bear_adventure_app/app/modules/trophy_cabinet/views/reward_part_video.view.dart';
import 'package:bear_adventure_app/app/modules/trophy_cabinet/views/trophy_cabinet.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bear_adventure_app/app/modules/home/views/home.view.dart';

part './app_routes.dart';

class AppPages {
  AppPages._();
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: '/',
      page: () => const RootView(),
      bindings: [
        RootBinding(),
        ProfilesBinding(),
        CardsBinding(),
      ],
      participatesInRootNavigator: true,
      preventDuplicates: true,
      children: [
        GetPage(
          fullscreenDialog: true,
          name: _Paths.splash,
          page: () => const SplashView(),
          title: 'Splash',
          transition: Transition.fade,
          bindings: [
            SplashBinding(),
          ],
        ),
        GetPage(
          preventDuplicates: true,
          fullscreenDialog: true,
          popGesture: false,
          name: _Paths.welcome,
          title: "Welcome",
          page: () => const WelcomeView(),
          bindings: [
            OnboardingBinding(),
          ],
        ),
        GetPage(
          preventDuplicates: true,
          name: _Paths.home,
          title: "Home",
          transition: Transition.native,
          showCupertinoParallax: true,
          page: () => const HomeView(),
          bindings: [
            HomeBinding(),
            CardsBinding(),
          ],
        ),
        GetPage(
          preventDuplicates: true,
          name: _Paths.trophyCabinet,
          title: "Trophy Cabinet",
          transition: Transition.native,
          showCupertinoParallax: true,
          participatesInRootNavigator: false,
          page: () => const TrophyCabinetView(),
          bindings: [
            TrophyCabinetBinding(),
          ],
        ),
        GetPage(
          preventDuplicates: false,
          name: _Paths.reward,
          title: "Reward",
          transition: Transition.native,
          showCupertinoParallax: true,
          participatesInRootNavigator: false,
          page: () => const RewardView(),
          bindings: [
            RewardBinding(),
          ],
        ),
        GetPage(
          fullscreenDialog: true,
          name: _Paths.rewardOrPartCompleted,
          title: "Reward or Part Complete",
          transition: Transition.fade,
          page: () => const RewardOrPartCompleteView(),
          bindings: [
            RewardOrPartCompleteBinding(),
          ],
        ),
        GetPage(
          fullscreenDialog: true,
          name: _Paths.rewardPartVideo,
          title: "Reward Video",
          transition: Transition.fade,
          page: () => const RewardPartVideoView(),
          bindings: [
            RewardPartVideoBinding(),
          ],
        ),
        GetPage(
          fullscreenDialog: true,
          name: _Paths.greatJob,
          title: "Reward Video",
          transition: Transition.fade,
          page: () => const GreatJobView(),
          bindings: [
            GreatJobBinding(),
          ],
        ),
        GetPage(
          preventDuplicates: true,
          name: _Paths.cards,
          title: null,
          transition: Transition.native,
          showCupertinoParallax: true,
          participatesInRootNavigator: false,
          page: () => const CardsView(color: Colors.blueAccent),
          bindings: [
            CardsBinding(),
          ],
        ),
        GetPage(
          name: _Paths.collection,
          title: "Collection",
          transition: Transition.native,
          showCupertinoParallax: true,
          page: () => const CardCollectionView(),
          bindings: [
            CardCollectionBinding(),
          ],
        ),
        GetPage(
          name: _Paths.set,
          title: "Set",
          transition: Transition.native,
          showCupertinoParallax: true,
          page: () => const CardSetView(),
          bindings: [
            CardSetBinding(),
          ],
        ),
        GetPage(
          name: _Paths.card,
          title: "Card",
          transition: Transition.native,
          showCupertinoParallax: true,
          page: () => const CardView(),
          bindings: [
            CardBinding(),
          ],
        ),
        GetPage(
          name: _Paths.showdown,
          title: "Showdown",
          transition: Transition.native,
          showCupertinoParallax: true,
          page: () => const CardShowdownView(),
          bindings: [
            CardShowdownBinding(),
            CardShowdownCountdownBinding(),
          ],
        ),
        GetPage(
          fullscreenDialog: true,
          participatesInRootNavigator: false,
          name: _Paths.showdownCountdown,
          title: "Showdown",
          transition: Transition.fade,
          showCupertinoParallax: false,
          page: () => const CardShowdownCountdownView(),
        ),
        GetPage(
          fullscreenDialog: true,
          participatesInRootNavigator: false,
          name: _Paths.full,
          title: "Card Full",
          transition: Transition.fade,
          showCupertinoParallax: true,
          page: () => CardFullView(),
          bindings: [
            CardBinding(),
          ],
        ),
        GetPage(
          fullscreenDialog: true,
          participatesInRootNavigator: false,
          name: _Paths.captureCard,
          title: "Card Capture",
          transition: Transition.fade,
          showCupertinoParallax: true,
          page: () => const CardCaptureView(),
          bindings: [
            CardCaptureBinding(),
          ],
        ),
        GetPage(
          fullscreenDialog: true,
          participatesInRootNavigator: false,
          name: _Paths.unlockCard,
          title: "Card Unlock",
          transition: Transition.circularReveal,
          transitionDuration: 10.seconds,
          showCupertinoParallax: true,
          page: () => const CardUnlockView(),
          bindings: [
            CardUnlockBinding(),
          ],
        ),
        GetPage(
          fullscreenDialog: true,
          participatesInRootNavigator: false,
          name: _Paths.setCompleted,
          title: "Set Completed",
          transition: Transition.fade,
          page: () => const SetCompletedView(),
          bindings: [
            SetCompletedBinding(),
          ],
        ),
        GetPage(
          fullscreenDialog: true,
          participatesInRootNavigator: false,
          name: _Paths.collectionCompleted,
          title: "Collection Completed",
          transition: Transition.fade,
          page: () => const CollectionCompletedView(),
          bindings: [
            CollectionCompletedBinding(),
          ],
        ),
        GetPage(
          preventDuplicates: true,
          name: _Paths.settings,
          title: null,
          transition: Transition.native,
          showCupertinoParallax: true,
          participatesInRootNavigator: false,
          page: () => const SettingsView(),
          bindings: [
            SettingsBinding(),
          ],
        ),
        GetPage(
          name: _Paths.permissions,
          page: () => const PermissionsView(),
          title: 'Permissions',
          transition: Transition.native,
          showCupertinoParallax: true,
          bindings: [
            PermissionsBinding(),
          ],
        ),
        GetPage(
          fullscreenDialog: true,
          name: _Paths.profiles,
          page: () => const ProfilesView(),
          title: 'Profiles',
          transition: Transition.fade,
          bindings: [
            ProfilesBinding(),
          ],
        ),
        GetPage(
          fullscreenDialog: true,
          name: _Paths.profileName,
          title: "Profile Name",
          transition: Transition.fade,
          showCupertinoParallax: true,
          page: () => const ProfileNameView(),
          bindings: [
            ProfileBinding(),
          ],
        ),
        GetPage(
          fullscreenDialog: true,
          name: _Paths.profileAvatar,
          title: "Profile Avatar",
          transition: Transition.fade,
          showCupertinoParallax: true,
          page: () => const ProfileAvatarView(),
          bindings: [
            ProfileBinding(),
          ],
        ),
        GetPage(
          preventDuplicates: true,
          name: _Paths.support,
          title: 'Help',
          transition: Transition.native,
          showCupertinoParallax: true,
          participatesInRootNavigator: false,
          page: () => const SupportView(),
          bindings: [
            SupportBinding(),
          ],
        ),
        GetPage(
          fullscreenDialog: true,
          name: _Paths.contact,
          page: () => const ContactView(),
          title: 'Contact',
          transition: Transition.fade,
          bindings: [
            ContactBinding(),
          ],
        ),
        GetPage(
          fullscreenDialog: true,
          name: _Paths.report,
          page: () => const ReportIssueView(),
          title: 'Report Issue',
          transition: Transition.fade,
          bindings: [
            ReportIssueBinding(),
          ],
        ),
        GetPage(
          fullscreenDialog: true,
          name: _Paths.privacy,
          page: () => const PrivacyPolicyView(),
          title: 'Privacy Policy',
          transition: Transition.fade,
          bindings: [
            PrivacyPolicyBinding(),
          ],
        ),
        GetPage(
          fullscreenDialog: true,
          name: _Paths.analyticsConsent,
          page: () => const AnalyticsConsentView(),
          title: 'Analytics Consent',
          transition: Transition.fade,
          bindings: [
            AnalyticsConsentBinding(),
          ],
        ),
        GetPage(
          fullscreenDialog: true,
          name: _Paths.guide,
          page: () => const HelpView(),
          title: 'Guide',
          transition: Transition.fade,
          bindings: [
            HelpBinding(),
          ],
        ),
      ],
    ),
  ];
}
