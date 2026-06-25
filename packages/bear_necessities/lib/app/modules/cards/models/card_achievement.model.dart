import 'package:bear_necessities/bear_necessities.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gamification/gamification.dart';

part 'card_achievement.model.freezed.dart';

part 'card_achievement.model.g.dart';

@pragma("vm:entry-point")
@freezed
sealed class CardAchievement<T, R>
    with _$CardAchievement<T, R>
    implements Achievement<T, R> {
  // ignore: unused_element
  const CardAchievement._();

  //@Implements<Achievement<T>>()
  //@Assert('type is CardAchievementType', 'type must be a CardAchievementType')
  const factory CardAchievement({
    @JsonKey(
        fromJson: CardAchievement.typeFromJson,
        toJson: CardAchievement.typeToJson)
    required dynamic type,
    required String id,
    @JsonKey(
        fromJson: CardAchievement.rewardTypeFromJson<CardRewardType>,
        toJson: CardAchievement.rewardTypeToJson<CardRewardType>)
    required dynamic rewardType,
    required num rewardAmount,
    required DateTime dateTime,
  }) = _CardAchievement;

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

  factory CardAchievement.fromJson(Map<String, Object?> json) =>
      _$CardAchievementFromJson(json);

  static Object? achievementToJson<T, R>(CardAchievement<T, R> achievement) {
    return achievement.toJson();
  }

  static CardAchievement<T, R> achievementFromJson<T, R>(Object? json) {
    return CardAchievement<T, R>.fromJson(json as Map<String, Object?>);
  }

  static T typeFromJson<T>(String json) {
    return CardAchievementType.values.byName(json) as T;
  }

  static String typeToJson<T>(T type) {
    return (type as CardAchievementType).name;
  }

  static T rewardTypeFromJson<T>(String json) {
    return CardRewardType.values.byName(json) as T;
  }

  static String rewardTypeToJson<T>(T type) {
    return (type as CardRewardType).name;
  }
}
