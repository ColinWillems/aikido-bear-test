// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_achievement.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CardAchievement<T, R> _$CardAchievementFromJson<T, R>(
        Map<String, dynamic> json) =>
    _CardAchievement<T, R>(
      type: CardAchievement.typeFromJson(json['type'] as String),
      id: json['id'] as String,
      rewardType:
          CardAchievement.rewardTypeFromJson(json['rewardType'] as String),
      rewardAmount: json['rewardAmount'] as num,
      dateTime: DateTime.parse(json['dateTime'] as String),
    );

Map<String, dynamic> _$CardAchievementToJson<T, R>(
        _CardAchievement<T, R> instance) =>
    <String, dynamic>{
      'type': CardAchievement.typeToJson(instance.type),
      'id': instance.id,
      'rewardType': CardAchievement.rewardTypeToJson(instance.rewardType),
      'rewardAmount': instance.rewardAmount,
      'dateTime': instance.dateTime.toIso8601String(),
    };
