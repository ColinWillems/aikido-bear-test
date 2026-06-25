import 'package:bear_adventure_app/app/modules/support/controllers/support.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:get/get.dart' hide GetNumUtils;
import 'package:flutter_animate/flutter_animate.dart';

class SupportView extends GetView<SupportController> {
  const SupportView({super.key});

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
                  LocaleKeys.help_title.tr,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineLarge?.w900.s56.hTitle
                      .copyWith(color: const Color(0xFFA32722)),
                ),
                AppStandardButton(
                  text: LocaleKeys.help_contact_button.tr,
                  color: const Color(0xFF84BC51),
                  onPressed: () => controller.navigation.contact(),
                ),
                AppStandardButton(
                  text: LocaleKeys.help_report_button.tr,
                  color: const Color(0xFF84BC51),
                  onPressed: () => controller.navigation.reportBug(),
                ),
                AppStandardButton(
                  text: LocaleKeys.help_privacy_policy_button.tr,
                  color: const Color(0xFF84BC51),
                  onPressed: () => controller.navigation.viewPrivacyPolicy(),
                ),
                AppStandardButton(
                  text: LocaleKeys.help_analytics_button.tr,
                  color: const Color(0xFF84BC51),
                  onPressed: () =>
                      controller.navigation.viewAnalyticsConsent(),
                ),
                AppStandardButton(
                  text: LocaleKeys.help_guide_button.tr,
                  color: const Color(0xFF84BC51),
                  onPressed: () => controller.navigation.viewGuide(),
                ),
              ].animate(interval: 200.ms).shake(duration: 300.ms, hz: 7),
            ),
          ),
        ));
  }
}
