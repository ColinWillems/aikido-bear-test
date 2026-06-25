import 'package:bear_adventure_app/app/modules/cards/controllers/card_capture.controller.dart';
import 'package:bear_adventure_app/app/modules/cards/views/widgets/code_scanner.dart';
import 'package:flutter/material.dart' hide Card, BackButton;
import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class CardCaptureView extends GetWidget<CardCaptureController> {
  const CardCaptureView({super.key, this.deepLink});
  final String? deepLink;

  @override
  Widget build(BuildContext context) {
    if (deepLink != null) {
      Future.delayed(700.ms, () => controller.captureCardFromUrl(deepLink!));
    }
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Obx(
      () {
        return (deepLink != null)
            ? const SizedBox.shrink()
            : Opacity(
                opacity: !controller.isUnlockingCard() ? 1 : 0,
                child: Scaffold(
                  extendBodyBehindAppBar: true,
                  backgroundColor: Colors.black,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    leading: const BackButton(),
                  ),
                  body: (controller.isRealDevice())
                      ? CodeScanner(
                          once: true,
                          onError: (error) {
                            final String message = error.toString();
                            if (!message.contains("setState")) {
                              controller.showScannerError(message);
                            }
                          },
                          onScan: (barcode) {
                            controller.captureCardFromQRCode(barcode);
                          },
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Wrap(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.black.withOpacity(0.25),
                                    hintText: "Test a URL...",
                                    hintStyle: textTheme.displayMedium?.w900.s20
                                        .transparentWhiteColor,
                                  ),
                                  style: textTheme.displayMedium?.w900.s20,
                                  cursorColor: BearColors.creamWhite,
                                  controller: controller.textEditingController,
                                  keyboardType: TextInputType.url,
                                  textAlign: TextAlign.center,
                                  enabled: true,
                                  autofocus: true,
                                ),
                                AppStandardButton(
                                  text:
                                      LocaleKeys.help_contact_submit_button.tr,
                                  color: BearColors.bearStandardButton,
                                  onPressed: () {
                                    controller.captureCardFromUrl(
                                        controller.textEditingController.text);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              );
      },
    );
  }
}
