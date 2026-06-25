import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bear_necessities/bear_necessities.dart';

export 'message_dialog.widget.dart';

abstract class Dialogs {
  static void showSnackbar({message = ""}) {
    Future.delayed(
      1.seconds,
      () => Get.snackbar(
        "",
        message,
        titleText: const SizedBox.shrink(),
        duration: 5.seconds,
        isDismissible: true,
        backgroundColor: BearColors.bearGreen,
        borderColor: BearColors.creamWhite,
        borderRadius: 8,
        borderWidth: 4,
        colorText: BearColors.creamWhite,
        messageText: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(Get.context!).textTheme.displayMedium!.s16,
        ),
        boxShadows: [
          BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: 0)
        ],
        snackPosition: SnackPosition.bottom,
        snackStyle: SnackStyle.floating,
      ),
    );
  }

  static Future<OkCancelResult> showErrorDialog(String message,
      [String? path]) async {
    return await showDialog(
      title: "Error",
      message: message,
      path: path ?? "/show-error",
    );
  }

  static Future<OkCancelResult> showDialog(
      {required String title,
      required String message,
      required String path,
      bool cancelable = false}) async {
    var dialogFunction = (!cancelable) ? _showOkDialog : _showOkCancelDialog;
    return await dialogFunction(
      title: title,
      message: message,
      path: path,
    );
  }

  static Future<OkCancelResult> _showOkDialog(
      {required String title,
      required String message,
      required String path,
      bool cancelable = false}) async {
    return await showOkAlertDialog(
      style: AdaptiveStyle.material,
      context: Get.context!,
      title: title,
      message: message,
      routeSettings: RouteSettings(name: path),
    );
  }

  static Future<OkCancelResult> _showOkCancelDialog(
      {required String title,
      required String message,
      required String path,
      bool cancelable = false}) async {
    return await showOkCancelAlertDialog(
      style: AdaptiveStyle.material,
      context: Get.context!,
      title: title,
      message: message,
      routeSettings: RouteSettings(name: path),
    );
  }

  static Future<T?> showActionDialog<T>({
    required String title,
    required String message,
    required String path,
    required List<AlertDialogAction<T>> actions,
  }) async {
    return await showAlertDialog<T>(
      context: Get.context!,
      title: title,
      message: message,
      barrierDismissible: true,
      style: AdaptiveStyle.material,
      actions: actions,
      routeSettings: RouteSettings(name: path),
    );
  }
}
