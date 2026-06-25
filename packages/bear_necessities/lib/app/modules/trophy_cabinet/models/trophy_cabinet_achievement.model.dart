import 'package:bear_necessities/bear_necessities.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gamification/gamification.dart';

part 'trophy_cabinet_achievement.model.freezed.dart';

part 'trophy_cabinet_achievement.model.g.dart';

@pragma("vm:entry-point")
@freezed
sealed class TrophyCabinetAchievement<T, R>
    with _$TrophyCabinetAchievement<T, R>
    implements Achievement<T, R> {
  // ignore: unused_element
  const TrophyCabinetAchievement._();

  const factory TrophyCabinetAchievement({
    @JsonKey(
        fromJson: TrophyCabinetAchievement.typeFromJson,
        toJson: TrophyCabinetAchievement.typeToJson)
    required dynamic type,
    required String id,
    @JsonKey(
        fromJson: TrophyCabinetAchievement
            .rewardTypeFromJson<TrophyCabinetRewardType>,
        toJson:
            TrophyCabinetAchievement.rewardTypeToJson<TrophyCabinetRewardType>)
    required dynamic rewardType,
    required num rewardAmount,
    required DateTime dateTime,
  }) = _TrophyCabinetAchievement;

  @override
  dynamic get type;
  @override
  String get id;
  @override
  dynamic get rewardType;
  @override
  num get rewardAmount;
  @override
  DateTime get dateTime;

  factory TrophyCabinetAchievement.fromJson(Map<String, Object?> json) =>
      _$TrophyCabinetAchievementFromJson(json);

  static Object? achievementToJson<T, R>(
      TrophyCabinetAchievement<T, R> achievement) {
    return achievement.toJson();
  }

  static TrophyCabinetAchievement<T, R> achievementFromJson<T, R>(
      Object? json) {
    return TrophyCabinetAchievement<T, R>.fromJson(
        json as Map<String, Object?>);
  }

  static T typeFromJson<T>(String json) {
    return TrophyCabinetAchievementType.values.byName(json) as T;
  }

  static String typeToJson<T>(T type) {
    return (type as TrophyCabinetAchievementType).name;
  }

  static T rewardTypeFromJson<T>(String json) {
    return TrophyCabinetRewardType.values.byName(json) as T;
  }

  static String rewardTypeToJson<T>(T type) {
    return (type as TrophyCabinetRewardType).name;
  }
}
