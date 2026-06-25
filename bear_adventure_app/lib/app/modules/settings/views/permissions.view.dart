import 'package:bear_adventure_app/app/modules/settings/controllers/permissions.controller.dart';
import 'package:bear_adventure_app/app/modules/settings/views/widgets/permissions_finish.widget.dart';
import 'package:bear_adventure_app/app/modules/settings/views/widgets/permissions_camera.widget.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:get/get.dart' hide GetNumUtils;
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PermissionsView extends GetWidget<PermissionsController> {
  const PermissionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final double padding = AppThemes.appLayout.padding.sm.left;
    final bool firstView = controller.firstView;
    final Color buttonColor =
        firstView ? const Color(0xFFF47C66) : const Color(0xFF84BC51);
    return Scaffold(
      backgroundColor: firstView ? null : const Color(0xFFE4826C),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const BackButton(),
      ),
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
                              rawPages: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                    bottom: 100,
                                    left: padding,
                                    right: padding,
                                  ),
                                   child: CameraPermissions(
                                     permissionStatus:
                                         controller.cameraPermission(),
                                     titleColor: firstView
                                         ? null
                                         : const Color(0xFFA32722),
                                   ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    bottom: 100,
                                    left: padding,
                                    right: padding,
                                  ),
                                  child: const PermissionsFinish(),
                                ),
                              ]),
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
                                           color: buttonColor,
                                         ),
                                      ),
                              ),
                              (!isLastStep)
                                  ? Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: AppStandardButton(
                                          text: (controller.currentStep() ==
                                                      PermissionsController
                                                          .cameraPermissionsPageIndex &&
                                                  !controller
                                                      .isCameraPermissionChecked())
                                              ? LocaleKeys
                                                  .help_guide_camera_access_button
                                                  .tr
                                              : LocaleKeys
                                                  .help_guide_next_button.tr,
                                          onPressed: () =>
                                              controller.nextStep(),
                                           color: buttonColor,
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
                                           color: buttonColor,
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
}
