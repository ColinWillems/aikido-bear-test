import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:avoid_keyboard/avoid_keyboard.dart' as avk;

class AndroidAvoidKeyboard extends Container {
  AndroidAvoidKeyboard({super.key, super.child, this.spacing});

  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return GetPlatform.isAndroid && child != null
        ? avk.AvoidKeyboard(
            spacing: spacing,
            child: child!,
          )
        : Container(child: child);
  }
}
