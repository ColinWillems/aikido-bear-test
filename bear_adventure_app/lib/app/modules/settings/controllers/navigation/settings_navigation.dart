import 'package:bear_adventure_app/app/routes/app_pages.dart';
import 'package:bear_adventure_app/app/utils/common.dart';
import 'package:bear_necessities/bear_necessities.dart';

class SettingsNavigation {
  SettingsNavigation({required this.profilesService, required this.urlService});
  final ProfilesService profilesService;
  final UrlService urlService;

  void viewPermissions() {
    Common.showFullScreenDialog(Routes.permissions, urlService,
        "${Routes.settings}${Routes.permissions}");
  }

  void viewHelp() {
    Common.navigateTo(Routes.support, urlService, Routes.support);
  }

  void viewGuide() {
    Common.showFullScreenDialog(
        Routes.guide, urlService, "${Routes.support}${Routes.guide}");
  }

  void viewWelcome() {
    Common.showFullScreenDialog(Routes.welcome, urlService, Routes.welcome);
  }

  void viewProfiles() {
    Common.showFullScreenDialog(
        Routes.profiles, urlService, "${Routes.settings}${Routes.profiles}");
  }

  void editProfileName() {
    Common.showFullScreenDialog(Routes.profileName, urlService,
        "${Routes.settings}${Routes.profiles}${Routes.profileName}");
  }

  void editProfileAvatar() {
    Common.showFullScreenDialog(Routes.profileAvatar, urlService,
        "${Routes.settings}${Routes.profiles}${Routes.profileAvatar}");
  }

  void viewAnalyticsConsent() {
    Common.showFullScreenDialog(Routes.analyticsConsent, urlService,
        "${Routes.support}${Routes.analyticsConsent}");
  }

  void goHome() {
    Common.navigateTo(Routes.home, urlService, Routes.cards,
        parameters: {"tab": "2"});
  }
}
