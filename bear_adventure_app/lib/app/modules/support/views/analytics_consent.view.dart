import 'package:bear_adventure_app/app/modules/support/controllers/analytics_consent.controller.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AnalyticsConsentView extends GetView<AnalyticsConsentController> {
  const AnalyticsConsentView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double padding = AppThemes.appLayout.padding.sm.left;

    return Obx(
      () {
        final bool firstView = controller.firstView();

        return WillPopScope(
          onWillPop: () async {
            if (firstView) {
              controller.goBack();
              return false;
            }
            return true;
          },
          child: Scaffold(
            backgroundColor:
                firstView ? null : const Color(0xFFE4826C),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: firstView
                  ? BackButton(onPressed: controller.goBack)
                  : const BackButton(),
              actions: const [
                SizedBox(width: 54),
              ],
              toolbarHeight: 206,
              titleSpacing: 0,
              title: Padding(
                // Extra bottom padding stops the descenders ('p' in "improve"
                // / "app") on the title's second line from being clipped by
                // the AppBar bottom edge.
                padding: const EdgeInsets.only(top: 18, bottom: 8),
                child: Text(
                  LocaleKeys.help_analytics_title.tr,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: firstView
                      ? textTheme.headlineMedium?.hSubtitle
                      : textTheme.headlineMedium?.hSubtitle
                          .copyWith(color: const Color(0xFFA32722)),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    LocaleKeys
                                        .help_analytics_parental_notice.tr,
                                    textAlign: TextAlign.center,
                                    style:
                                        textTheme.labelMedium?.hSubtitle.copyWith(
                                      color: BearColors.bearBrown,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Html(
                                    onLinkTap: (url, attributes, element) {
                                      if (url != null) {
                                        launchUrl(Uri.parse(url),
                                            mode: LaunchMode.inAppWebView);
                                      }
                                    },
                                    style: _htmlStyle(),
                                    data: LocaleKeys
                                        .help_analytics_content.tr,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.4,
                            child: Checkbox(
                              value: controller.consentChecked(),
                              onChanged: (bool? value) {
                                if (value != null) {
                                  controller.toggleConsent(value);
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: MaterialButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => controller.toggleConsent(
                                  !controller.consentChecked()),
                              child: Text(
                                LocaleKeys.help_analytics_consent.tr,
                                style: textTheme.labelSmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12, left: 24, right: 24),
                        child: AppStandardButton(
                          text: LocaleKeys
                              .help_analytics_continue_without_button.tr,
                          color: const Color(0xFFF47C66),
                          onPressed: controller.continueWithoutAnalytics,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12, left: 24, right: 24),
                        child: AppStandardButton(
                          text: LocaleKeys
                              .help_analytics_continue_with_button.tr,
                          color: const Color(0xFF84BC51),
                          onPressed: controller.consentChecked()
                              ? controller.continueWithAnalytics
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Map<String, Style> _htmlStyle() {
    return {
      "body": Style(
        color: BearColors.bearBrown,
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
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
        textDecoration: TextDecoration.underline,
      ),
    };
  }
}
