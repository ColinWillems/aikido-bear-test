import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.model.freezed.dart';

part 'profile.model.g.dart';

@pragma("vm:entry-point")
@freezed
sealed class Profile with _$Profile {
  const Profile._();
  @JsonSerializable(explicitToJson: true)
  const factory Profile({
    @Default(Profiles.defaultId) String id,
    @Default("") String name,
    @Default(0) int index,
    @JsonKey(fromJson: ColorUtil.fromJson, toJson: Profile.colorToJson)
    @Default(BearColors.bearAvatarBlue)
    Color color,
    @JsonKey(
        fromJson: Profile.decorationsListFromJson,
        toJson: Profile.decorationsListToJson)
    @Default(<ProfileDecoration>[
      ProfileDecoration.baseballCap,
      ProfileDecoration.sunglasses
    ])
    List<ProfileDecoration> decorations,
  }) = _Profile;

  @override
  String get id;
  @override
  String get name;
  @override
  int get index;
  @override
  Color get color;
  @override
  List<ProfileDecoration> get decorations;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  static Object? profileToJson(Profile profile) {
    return profile.toJson();
  }

  static Profile profileFromJson(Object? json) {
    return Profile.fromJson(json as Map<String, Object?>);
  }

  static List<ProfileDecoration> decorationsListFromJson(Object? json) {
    final decorations = <ProfileDecoration>[];
    if (json != null && json is List<dynamic>) {
      for (var element in json) {
        ProfileDecoration? decoration = ProfileDecoration.byShortName(element);
        if (decoration != null) {
          decorations.add(decoration);
        }
      }
    }
    return decorations;
  }

  static Object? decorationsListToJson(List<ProfileDecoration> decorations) {
    return decorations.map((decoration) => decoration.shortName).toList();
  }

  static Object? colorToJson(Color color) {
    final output = color.toJson();

    return output;
  }
}
