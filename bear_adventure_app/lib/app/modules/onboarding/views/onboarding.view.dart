import 'package:bear_adventure_app/app/modules/onboarding/controllers/onboarding.controller.dart';
import 'package:bear_adventure_app/app/modules/onboarding/views/welcome.view.dart';
import 'package:bear_adventure_app/app/modules/settings/views/profile_name.view.dart';
import 'package:bear_adventure_app/app/modules/support/views/privacy_policy.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IntroductionScreen(
                  rawPages: const [
                    WelcomeView(),
                    PrivacyPolicyView(),
                    ProfileNameView(),
                  ],
                  isProgress: false,
                  showSkipButton: false,
                  showBackButton: false,
                  nextSemantic: "Next Step",
                  doneSemantic: "Save",
                  nextStyle: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF47C66),
                    foregroundColor: Colors.white,
                  ),
                  doneStyle: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF47C66),
                    foregroundColor: Colors.white,
                  ),
                  globalFooter: Container(
                    alignment: Alignment.bottomRight,
                    child: const Text("BEAR"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
