// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bear_reward.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BearReward _$BearRewardFromJson(Map<String, dynamic> json) => _BearReward(
      id: json['id'] as String? ?? TrophyCabinet.defaultRewardId,
      index: (json['index'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? "",
      kind: $enumDecodeNullable(_$BearRewardKindEnumMap, json['kind']) ??
          BearRewardKind.cardCollection,
      intro: json['intro'] as String? ?? "",
      outro: json['outro'] as String? ?? "",
      parts: (json['parts'] as List<dynamic>?)
              ?.map((e) => BearRewardPart.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <BearRewardPart>[],
    );

Map<String, dynamic> _$BearRewardToJson(_BearReward instance) =>
    <String, dynamic>{
      'id': instance.id,
      'index': instance.index,
      'name': instance.name,
      'kind': _$BearRewardKindEnumMap[instance.kind]!,
      'intro': instance.intro,
      'outro': instance.outro,
      'parts': instance.parts.map((e) => e.toJson()).toList(),
    };

const _$BearRewardKindEnumMap = {
  BearRewardKind.cardCollection: 'cardCollection',
};
