import 'dart:io';

import 'package:bear_adventure_app/app/modules/support/controllers/help.controller.dart';
import 'package:bear_adventure_app/app/modules/support/views/widgets/guide_finish.widget.dart';
import 'package:bear_adventure_app/app/modules/support/views/widgets/guide_instructions.widget.dart';
import 'package:bear_adventure_app/app/modules/support/views/widgets/guide_camera_permissions.widget.dart';
import 'package:bear_adventure_app/app/modules/support/views/widgets/guide_pasteboard_permissions.widget.dart';
import 'package:bear_adventure_app/app/modules/support/views/widgets/guide_summary.widget.dart';
import 'package:bear_adventure_app/app/modules/support/views/widgets/guide_welcome.widget.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide GetNumUtils;
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HelpView extends GetView<HelpController> {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    final double padding = AppThemes.appLayout.padding.sm.left;
    final String welcomeName = controller.welcomeName();
    return Scaffold(
      backgroundColor: BearColors.bearGreen,
      body: Container(
        padding: const EdgeInsets.only(
          top: 18,
          bottom: 18,
        ),
        alignment: Alignment.center,
        child: Obx(
          () {
            final bool isLastStep = controller.isLastStep();
            return SafeArea(
              child: Column(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned.fill(
                          child: IntroductionScreen(
                              key: controller.stepsKey,
                              allowImplicitScrolling: true,
                              scrollPhysics:
                                  const AlwaysScrollableScrollPhysics(),
                              controlsPosition: const Position(
                                bottom: -10,
                                left: 0,
                                right: 0,
                              ),
                              controlsMargin: const EdgeInsets.all(0),
                              showSkipButton: false,
                              showBackButton: false,
                              showDoneButton: false,
                              showNextButton: false,
                              dotsFlex: 0,
                              dotsDecorator: DotsDecorator(
                                spacing: const EdgeInsets.all(2),
                                color: BearColors.creamWhite.withOpacity(0.25),
                                activeColor: BearColors.creamWhite,
                                size: const Size(14, 14),
                                activeSize: const Size(14, 14),
                                shape: BearFoot(
                                  size: 14,
                                  color: BearColors.creamWhite.withOpacity(0.25),
                                ),
                                activeShape: const BearFoot(
                                    size: 14, color: BearColors.creamWhite),
                              ),
                              globalBackgroundColor: Colors.transparent,
                              onChange: controller.onStepChange,
                              rawPages: _buildPages(padding, welcomeName)),
                        ),
                        Positioned(
                          bottom: 36,
                          height: 50,
                          left: padding,
                          right: padding,
                          child: Row(
                            children: [
                              Flexible(
                                child: (controller.isFirstStep.value)
                                    ? Container()
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: AppStandardButton(
                                          text: LocaleKeys
                                              .shared_buttons_previous.tr,
                                          onPressed: () =>
                                              controller.previousStep(),
                                          color: const Color(0xFFF47C66),
                                        ),
                                      ),
                              ),
                              (!isLastStep)
                                  ? Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: AppStandardButton(
                                          text: _getNextButtonText(),
                                          onPressed: () =>
                                              controller.nextStep(),
                                          color: const Color(0xFFF47C66),
                                        ),
                                      ),
                                    )
                                  : Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: AppStandardButton(
                                          text: LocaleKeys
                                              .help_guide_done_button.tr,
                                          onPressed: () =>
                                              controller.finishGuide(),
                                          color: const Color(0xFFF47C66),
                                        ),
                                      ),
                                    ),
                            ].animate(interval: 200.ms).shake(
                                  duration: 300.ms,
                                  hz: 7,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _getNextButtonText() {
    final currentStep = controller.currentStep();

    if (currentStep == HelpController.cameraPermissionsPageIndex &&
        !controller.isCameraPermissionChecked()) {
      return LocaleKeys.help_guide_camera_access_button.tr;
    }

    if (Platform.isIOS &&
        currentStep == HelpController.pasteboardPermissionsPageIndex &&
        !controller.isPasteboardPermissionChecked()) {
      return LocaleKeys.help_guide_pasteboard_access_button.tr;
    }

    return LocaleKeys.help_guide_next_button.tr;
  }

  List<Widget> _buildPages(double padding, String welcomeName) {
    final List<Widget> pages = [
      Container(
        padding: EdgeInsets.only(
          bottom: 100,
          left: padding,
          right: padding,
        ),
        child: GuideWelcome(name: welcomeName),
      ),
      Container(
        padding: EdgeInsets.only(
          bottom: 100,
          left: padding,
          right: padding,
        ),
        child: const GuideInstructions(),
      ),
      Container(
        padding: EdgeInsets.only(
          bottom: 100,
          left: padding,
          right: padding,
        ),
        child: GuideCameraPermissions(
          permissionStatus: controller.cameraPermission(),
        ),
      ),
    ];

    pages.add(
      Container(
        padding: EdgeInsets.only(
          bottom: 100,
          left: padding,
          right: padding,
        ),
        child: const GuideSummary(),
      ),
    );

    // Add pasteboard permissions page on iOS (before finish)
    if (Platform.isIOS) {
      pages.add(
        Container(
          padding: EdgeInsets.only(
            bottom: 100,
            left: padding,
            right: padding,
          ),
          child: GuidePasteboardPermissions(
            isPermissionChecked: controller.isPasteboardPermissionChecked(),
            clipboardContent:
                controller.deferredDeepLinkService.lastClipboardContent(),
          ),
        ),
      );
    }

    pages.add(
      Container(
        padding: EdgeInsets.only(
          bottom: 100,
          left: padding,
          right: padding,
        ),
        child: const GuideFinish(),
      ),
    );

    return pages;
  }
}
