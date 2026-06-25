import 'dart:ui';

import 'package:bear_adventure_app/app/modules/support/controllers/report_issue.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:get/get.dart' hide GetNumUtils;
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:avoid_keyboard/avoid_keyboard.dart';

class ReportIssueView extends GetView<ReportIssueController> {
  const ReportIssueView({super.key});
  

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double padding = AppThemes.appLayout.padding.sm.left;
    final FlutterView window = View.of(context);
    final double topSafeArea = window.viewPadding.top / window.devicePixelRatio;

    return Obx(
      () {
        final bool isValid = controller.formIsValid();
        final bool isLastStep = controller.isLastStep();

        final formKey = controller.formKey;

        void previousStepWithAutofocus() {
          controller.previousStep();
          Future.delayed(400.ms, FocusScope.of(context).nextFocus);
        }

        void nextStepWithAutofocus() {
          controller.nextStep();
          Future.delayed(400.ms, FocusScope.of(context).nextFocus);
        }

        return Scaffold(
          backgroundColor: const Color(0xFFE4826C),
          extendBodyBehindAppBar: false,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: kToolbarHeight,
                child: Row(
                  children: const [
                    SizedBox(
                      width: 56,
                      height: kToolbarHeight,
                      child: BackButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.only(bottom: 18),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 80 + topSafeArea,
                  floating: true,
                  snap: false,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 0,
                          left: padding,
                          right: padding,
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          direction: Axis.horizontal,
                          runSpacing: 12,
                          children: [
                            Text(
                              LocaleKeys.help_report_title.tr,
                              textAlign: TextAlign.center,
                              style: textTheme.headlineMedium
                                  ?.copyWith(color: const Color(0xFFA32722)),
                            ),
                            Text(
                              LocaleKeys.help_report_content.tr,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyLarge?.s22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: false,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 370),
                    child: AvoidKeyboard(
                      spacing: 40,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned.fill(
                            child: Form(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              key: formKey,
                              child: FocusTraversalGroup(
                                policy: WidgetOrderTraversalPolicy(),
                                child: IntroductionScreen(
                                  key: controller.stepsKey,
                                  allowImplicitScrolling: false,
                                  scrollPhysics:
                                      const AlwaysScrollableScrollPhysics(),
                                  controlsPosition: const Position(
                                      bottom: -10, left: 0, right: 0),
                                  controlsMargin: const EdgeInsets.all(0),
                                  bodyPadding:
                                      const EdgeInsets.only(bottom: 100),
                                  showSkipButton: false,
                                  showBackButton: false,
                                  showDoneButton: false,
                                  showNextButton: false,
                                  freeze: !isValid,
                                  dotsFlex: 0,
                                  isProgressTap: false,
                                  dotsDecorator: DotsDecorator(
                                    spacing: const EdgeInsets.all(2),
                                    color:
                                        BearColors.creamWhite.withOpacity(0.25),
                                    activeColor: BearColors.creamWhite,
                                    size: const Size(14, 14),
                                    activeSize: const Size(14, 14),
                                    shape: BearFoot(
                                        size: 14,
                                        color: BearColors.creamWhite
                                            .withOpacity(0.25)),
                                    activeShape: const BearFoot(
                                        size: 14, color: BearColors.creamWhite),
                                  ),
                                  globalBackgroundColor: Colors.transparent,
                                  onChange: controller.onStepChange,
                                  rawPages: <Widget>[
                                     Padding(
                                       padding: EdgeInsets.only(
                                         top: 12,
                                         bottom: 12,
                                         left: padding,
                                         right: padding,
                                       ),
                                       child: Column(
                                         mainAxisSize: MainAxisSize.min,
                                         crossAxisAlignment:
                                             CrossAxisAlignment.stretch,
                                         children: [
                                            AppTextFormField(
                                              autofocus: false,
                                              decoration: AppInputDecoration(
                                                labelStyle: textTheme
                                                    .displayMedium?.s27,
                                                alignLabelWithHint: true,
                                                hintText: "Your name...",
                                               hintStyle: textTheme
                                                   .displayMedium
                                                   ?.s27
                                                   .copyWith(
                                                       color: BearColors
                                                           .bearBrown
                                                           .withOpacity(0.5)),
                                               errorStyle: textTheme
                                                   .labelSmall?.errorColor,
                                             ),
                                             cursorColor: BearColors.bearBrown,
                                             style: textTheme.displayMedium
                                                 ?.s27
                                                 .copyWith(
                                                     color:
                                                         BearColors.bearBrown),
                                             keyboardType: TextInputType.name,
                                             textInputAction:
                                                 TextInputAction.next,
                                             controller: controller
                                                 .nameEditingController,
                                             validator: controller
                                                 .getValidatorForField("Name",
                                                     TextInputType.name),
                                           ),
                                           const SizedBox(height: 20),
                                            AppTextFormField(
                                              autofocus: false,
                                              decoration: AppInputDecoration(
                                                hintText:
                                                    "Your email address...",
                                               hintStyle: textTheme
                                                   .displayMedium
                                                   ?.s27
                                                   .copyWith(
                                                       color: BearColors
                                                           .bearBrown
                                                           .withOpacity(0.5)),
                                               errorStyle: textTheme
                                                   .labelSmall?.errorColor,
                                             ),
                                             cursorColor: BearColors.bearBrown,
                                             style: textTheme.displayMedium
                                                 ?.s27
                                                 .copyWith(
                                                     color:
                                                         BearColors.bearBrown),
                                             keyboardType:
                                                 TextInputType.emailAddress,
                                             textInputAction:
                                                 TextInputAction.next,
                                             onEditingComplete: () {
                                               if (isValid) {
                                                 nextStepWithAutofocus();
                                               }
                                             },
                                             controller: controller
                                                 .emailAddressEditingController,
                                             validator: controller
                                                 .getValidatorForField(
                                                     "Email address",
                                                     TextInputType
                                                         .emailAddress),
                                           ),
                                           const SizedBox(height: 20),
                                            Obx(
                                               () => AppDropdownFormField<
                                                   SupportCountry>(
                                                 value: controller.country.value,
                                                onChanged:
                                                    controller.onCountryChanged,
                                                hint: Text(
                                                  "Select your country...",
                                                  style: textTheme.displayMedium
                                                      ?.s27
                                                      .copyWith(
                                                          color: BearColors
                                                              .bearBrown
                                                              .withOpacity(
                                                                  0.5)),
                                                ),
                                                style: textTheme.displayMedium
                                                    ?.s27
                                                    .copyWith(
                                                        color:
                                                            BearColors.bearBrown),
                                                decoration: AppInputDecoration(
                                                  errorStyle: textTheme
                                                      .labelSmall?.errorColor,
                                                ),
                                                menuItemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: padding),
                                                validator:
                                                    (SupportCountry? value) =>
                                                        value == null
                                                            ? "Please select your country"
                                                            : null,
                                                items: SupportCountry.values
                                                    .map(
                                                      (SupportCountry c) =>
                                                          DropdownMenuItem<
                                                              SupportCountry>(
                                                        value: c,
                                                        child: Text(
                                                          c.label,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                         ],
                                        ),
                                      ),
                                     Padding(
                                       padding: EdgeInsets.only(
                                         top: 12,
                                         bottom: 12,
                                         left: padding,
                                         right: padding,
                                       ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                             AppTextFormField(
                                               autofocus: false,
                                               decoration: AppInputDecoration(
                                                 hintText: "Description...",
                                                hintStyle: textTheme
                                                    .displayMedium
                                                    ?.s27
                                                    .copyWith(
                                                        color: BearColors
                                                            .bearBrown
                                                            .withOpacity(0.5)),
                                                errorStyle: textTheme
                                                    .labelSmall?.errorColor,
                                              ),
                                              cursorColor:
                                                  BearColors.bearBrown,
                                              style: textTheme.displayMedium
                                                  ?.s27
                                                  .copyWith(
                                                      color:
                                                          BearColors.bearBrown),
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              controller: controller
                                                  .subjectEditingController,
                                              validator: controller
                                                  .getValidatorForField(
                                                      "Description",
                                                      TextInputType.text),
                                            ),
                                            const SizedBox(height: 20),
                                             AppTextFormField(
                                               autofocus: false,
                                               decoration: AppInputDecoration(
                                                 hintText:
                                                     "What you did...\nWhat happened...\nWhat you expected...",
                                                hintStyle: textTheme
                                                    .displayMedium
                                                    ?.s27
                                                    .copyWith(
                                                        color: BearColors
                                                            .bearBrown
                                                            .withOpacity(0.5)),
                                                errorStyle: textTheme
                                                    .labelSmall?.errorColor,
                                              ),
                                              cursorColor:
                                                  BearColors.bearBrown,
                                              style: textTheme.displayMedium
                                                  ?.s27
                                                  .copyWith(
                                                      color:
                                                          BearColors.bearBrown),
                                              keyboardType:
                                                  TextInputType.multiline,
                                              textInputAction:
                                                  TextInputAction.send,
                                              onFieldSubmitted: (value) =>
                                                  isValid
                                                      ? controller.submitForm()
                                                      : null,
                                              maxLines: 3,
                                              controller: controller
                                                  .messageEditingController,
                                              validator: controller
                                                  .getValidatorForField(
                                                      "Details",
                                                      TextInputType.multiline),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
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
                                                .help_report_previous_button.tr,
                                            onPressed: () =>
                                                previousStepWithAutofocus(),
                                            color: const Color(0xFF84BC51),
                                          ),
                                        ),
                                ),
                                (!isLastStep)
                                    ? Flexible(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: AppStandardButton(
                                            text: LocaleKeys
                                                .help_report_next_button.tr,
                                            onPressed: isValid
                                                ? () => nextStepWithAutofocus()
                                                : null,
                                            color: const Color(0xFF84BC51),
                                          ),
                                        ),
                                      )
                                    : Flexible(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: AppStandardButton(
                                            text: LocaleKeys
                                                .help_report_submit_button.tr,
                                            onPressed: isValid
                                                ? () => controller.submitForm()
                                                : null,
                                            color: const Color(0xFF84BC51),
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
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
