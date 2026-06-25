// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trophy_cabinet_achievement.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrophyCabinetAchievement<T, R> _$TrophyCabinetAchievementFromJson<T, R>(
        Map<String, dynamic> json) =>
    _TrophyCabinetAchievement<T, R>(
      type: TrophyCabinetAchievement.typeFromJson(json['type'] as String),
      id: json['id'] as String,
      rewardType: TrophyCabinetAchievement.rewardTypeFromJson(
          json['rewardType'] as String),
      rewardAmount: json['rewardAmount'] as num,
      dateTime: DateTime.parse(json['dateTime'] as String),
    );

Map<String, dynamic> _$TrophyCabinetAchievementToJson<T, R>(
        _TrophyCabinetAchievement<T, R> instance) =>
    <String, dynamic>{
      'type': TrophyCabinetAchievement.typeToJson(instance.type),
      'id': instance.id,
      'rewardType':
          TrophyCabinetAchievement.rewardTypeToJson(instance.rewardType),
      'rewardAmount': instance.rewardAmount,
      'dateTime': instance.dateTime.toIso8601String(),
    };
