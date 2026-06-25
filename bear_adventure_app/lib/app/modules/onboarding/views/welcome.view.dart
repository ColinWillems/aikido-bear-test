import 'package:bear_adventure_app/app/modules/onboarding/controllers/onboarding.controller.dart';
import 'package:bear_adventure_app/app/modules/settings/views/widgets/profile_avatar.widget.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeView extends GetView<OnboardingController> {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        primary: true,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: Container(
          alignment: Alignment.center,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(
                  top: 18, right: 14, left: 14, bottom: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Wrap(
                      alignment: WrapAlignment.center,
                      direction: Axis.horizontal,
                      runSpacing: 12,
                      children: [
                        Center(
                            child: Text(
                          LocaleKeys.onboarding_welcome_title.tr,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineLarge,
                        ))
                      ]),
                  const Flexible(
                    fit: FlexFit.tight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      child: Center(
                          child: ProfileAvatar(
                              width: 240, color: BearColors.bearGreen)),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 24, left: 54, right: 54),
                    child: AppStandardButton(
                      text: LocaleKeys.onboarding_welcome_button.tr,
                      onPressed: () => controller.viewPrivacyPolicy(),
                      color: const Color(0xFFF47C66),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
