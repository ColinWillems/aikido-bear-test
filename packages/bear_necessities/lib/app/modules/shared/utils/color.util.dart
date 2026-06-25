import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

class ColorUtil {
  static Color fromJson(Object? json) {
    return TinyColor.fromString("#$json").toColor();
  }

  static Object? toJson(Color color) {
    return color.toJson();
  }
}

extension ColorJson on Color {
  String toJson() {
    return toTinyColor().toHex8().substring(2);
  }
}
