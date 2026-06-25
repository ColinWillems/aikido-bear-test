// ignore_for_file: unused_element

import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';

enum ProfileDecoration implements ProfileCustomisation {
  watermelonHat(
    "wmh",
    yPosition: 0.07,
    width: 0.35,
    type: ProfileDecorationType.hat,
  ),
  baseballCap(
    "bbc",
    yPosition: 0.05,
    width: 0.38,
    type: ProfileDecorationType.hat,
  ),
  headphones(
    "hph",
    yPosition: 0.1,
    width: 0.40,
    type: ProfileDecorationType.hat,
  ),
  sunglasses(
    "sun",
    yPosition: 0.17,
    width: 0.3,
    type: ProfileDecorationType.accessory,
  ),
  scarf(
    "scf",
    yPosition: 0.32,
    width: 0.7,
    type: ProfileDecorationType.accessory,
  ),
  sweater(
    "swb",
    yPosition: 0.56,
    width: 0.74,
    type: ProfileDecorationType.accessory,
  );

  const ProfileDecoration(
    this.shortName, {
    this.yPosition,
    this.width,
    this.type = ProfileDecorationType.hat,
  });
  final String shortName;
  final double? xPosition = null;
  final double? yPosition;
  final double? width;
  final double? height = null;
  final ProfileDecorationType type;

  static ProfileDecoration? byShortName(String shortName) {
    return ProfileDecoration.values.firstWhere(
      (decoration) => decoration.shortName == shortName,
    );
  }

  static ProfileDecoration? fromJson(Object? decoration) {
    return ProfileDecoration.byShortName(decoration as String);
  }

  String toJson(ProfileDecoration decoration) => decoration.shortName;

  Image toImage() {
    Map<String, Image> decorationToImageMap = {
      ProfileDecoration.watermelonHat.shortName: BearAssets
          .images.settings.profile.accessories.watermelonHat
          .image(package: BearApp.bearNecessities),
      ProfileDecoration.baseballCap.shortName: BearAssets
          .images.settings.profile.accessories.baseballCap
          .image(package: BearApp.bearNecessities),
      ProfileDecoration.headphones.shortName: BearAssets
          .images.settings.profile.accessories.headphones
          .image(package: BearApp.bearNecessities),
      ProfileDecoration.sunglasses.shortName: BearAssets
          .images.settings.profile.accessories.sunglasses
          .image(package: BearApp.bearNecessities),
      ProfileDecoration.scarf.shortName: BearAssets
          .images.settings.profile.accessories.scarf
          .image(package: BearApp.bearNecessities),
      ProfileDecoration.sweater.shortName: BearAssets
          .images.settings.profile.accessories.sweater
          .image(package: BearApp.bearNecessities),
    };
    return decorationToImageMap[shortName]!;
  }

  @override
  List<Object> get props => [shortName];

  @override
  bool? get stringify => true;
}
