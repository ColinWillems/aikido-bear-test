import 'package:bear_adventure_app/app/modules/support/controllers/privacy_policy.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double padding = AppThemes.appLayout.padding.sm.left;
    return Obx(
      () {
        final bool firstView = controller.firstView();
        final String subtitle = (firstView)
            ? LocaleKeys.help_privacy_policy_first_time_subtitle.tr
            : LocaleKeys.help_privacy_policy_subsequently_subtitle.tr;
        final String buttonText = (firstView)
            ? LocaleKeys.help_privacy_policy_first_time_button.tr
            : LocaleKeys.help_privacy_policy_subsequently_button.tr;

        return WillPopScope(
          onWillPop: () async => !firstView,
          child: Scaffold(
            backgroundColor:
                firstView ? null : const Color(0xFFE4826C),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: firstView ? const SizedBox.shrink() : const BackButton(),
              actions: const [
                SizedBox(width: 54),
              ],
              toolbarHeight: 146,
              titleSpacing: 0,
              title: Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  direction: Axis.horizontal,
                  runSpacing: 12,
                  children: [
                    Center(
                      child: Text(
                        subtitle,
                        textWidthBasis: TextWidthBasis.parent,
                        textAlign: TextAlign.center,
                        style: firstView
                            ? textTheme.headlineMedium?.s20
                            : textTheme.headlineMedium?.s20
                                .copyWith(color: const Color(0xFFA32722)),
                      ),
                    ),
                    Text(
                      LocaleKeys.help_privacy_policy_title.tr,
                      textAlign: TextAlign.center,
                      style: firstView
                          ? textTheme.headlineMedium
                          : textTheme.headlineMedium
                              ?.copyWith(color: const Color(0xFFA32722)),
                    ),
                  ],
                ),
              ),
            ),
            body: Container(
              alignment: Alignment.center,
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.only(
                      top: 0, right: padding, left: padding, bottom: 18),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Flexible(
                          fit: FlexFit.tight,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF6EDD2),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Html(
                                      onLinkTap: (url, attributes, element) {
                                        if (url != null) {
                                          launchUrl(Uri.parse(url),
                                              mode: LaunchMode.inAppWebView);
                                        }
                                      },
                                      style: {
                                        "body": Style(
                                          color: BearColors.bearBrown,
                                        ),
                                        "div": Style(
                                          padding: HtmlPaddings.zero,
                                          margin: Margins.only(bottom: 10),
                                        ),
                                        "h1, h2, h3, h4, h5, h6, p": Style(
                                          padding: HtmlPaddings.zero,
                                          margin: Margins.only(bottom: 14),
                                        ),
                                        'ul': Style(
                                          padding: HtmlPaddings(
                                            inlineStart: HtmlPadding(12),
                                          ),
                                        ),
                                        "h1, h2, h3, h4, h5, h6": Style(
                                          fontFamily: BearFonts.ursa,
                                          color: BearColors.bearBrown,
                                        ),
                                        "a": Style(
                                          color: BearColors.bearBrown,
                                          textDecoration:
                                              TextDecoration.underline,
                                        ),
                                      },
                                      data: LocaleKeys
                                          .help_privacy_policy_content.tr,
                                    ),
                                  ))),
                        ),
                        (firstView)
                            ? Row(
                                children: [
                                  Transform.scale(
                                    scale: 1.4,
                                    child: Checkbox(
                                      value: controller.accepted(),
                                      onChanged: (bool? value) {
                                        if (value != null) {
                                          controller.accepted(value);
                                        }
                                      },
                                    ),
                                  ),
                                  MaterialButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () => controller
                                          .accept(!controller.accepted()),
                                      child: Text(
                                        LocaleKeys
                                            .help_privacy_policy_first_time_confirm
                                            .tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      ))
                                ],
                              )
                            : const SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 24, left: 54, right: 54),
                          child: AppStandardButton(
                            text: buttonText,
                            color: firstView
                                ? const Color(0xFFF47C66)
                                : const Color(0xFF84BC51),
                            onPressed: (!firstView || controller.accepted())
                                ? controller.closeDialog
                                : null,
                          ),
                        )
                      ]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
