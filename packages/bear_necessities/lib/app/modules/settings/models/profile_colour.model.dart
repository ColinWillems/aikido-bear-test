import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

enum ProfileColour implements ProfileCustomisation {
  blue("86B0EF"),
  pink("EA85C9"),
  orange("F09B42");

  const ProfileColour(this.shortName);
  final String shortName;

  static ProfileColour? byShortName(String shortName) {
    return ProfileColour.values
        .firstWhere((colour) => colour.shortName == shortName);
  }

  Color toColor() => TinyColor.fromString("#$shortName").toColor();

  @override
  List<Object> get props => [shortName];

  @override
  bool? get stringify => true;
}
