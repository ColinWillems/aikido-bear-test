import 'package:bear_adventure_app/app/modules/settings/controllers/settings.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:get/get.dart' hide GetNumUtils;
import 'package:flutter_animate/flutter_animate.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double padding = AppThemes.appLayout.padding.sm.left;
    return Scaffold(
        backgroundColor: const Color(0xFFE4826C),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: const BackButton(),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.only(
                top: 18, right: 56 + padding, left: 56 + padding, bottom: 18),
            child: Wrap(
              alignment: WrapAlignment.center,
              direction: Axis.horizontal,
              runSpacing: 10,
              children: [
                Text(
                  LocaleKeys.settings_title.tr,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineLarge?.w900.s56.hTitle
                      .copyWith(color: const Color(0xFFA32722)),
                ),
                AppStandardButton(
                  text: LocaleKeys.settings_profiles_button.tr,
                  color: const Color(0xFF84BC51),
                  onPressed: () => controller.navigation.viewProfiles(),
                ),
                AppStandardButton(
                  text: LocaleKeys.settings_permissions_button.tr,
                  color: const Color(0xFF84BC51),
                  onPressed: () => controller.navigation.viewPermissions(),
                ),
                AppStandardButton(
                  text: LocaleKeys.settings_help_button.tr,
                  color: const Color(0xFF84BC51),
                  onPressed: () => controller.navigation.viewHelp(),
                ),
              ].animate(interval: 200.ms).shake(duration: 300.ms, hz: 7),
            ),
          ),
        ));
  }
}
