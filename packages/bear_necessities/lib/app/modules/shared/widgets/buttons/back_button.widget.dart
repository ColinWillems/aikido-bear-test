import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackButton extends StatelessWidget {
  const BackButton({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
            padding: const EdgeInsets.only(left: 10),
            constraints: const BoxConstraints(maxWidth: 54, maxHeight: 50),
            child: RoundPushableButton(
              tooltip: "Back",
              onPressed: onPressed ??
                  () {
                    if (Get.isDialogOpen ?? false) {
                      Get.close(closeAll: false);
                    } else {
                      Get.back();
                    }
                  },
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: BearAssets.images.global.icons.backIcon
                      .image(package: BearApp.bearNecessities)),
            )));
  }
}
