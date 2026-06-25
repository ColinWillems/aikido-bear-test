// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bear_reward_part.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BearRewardPart _$BearRewardPartFromJson(Map<String, dynamic> json) =>
    _BearRewardPart(
      id: json['id'] as String? ?? "",
      name: json['name'] as String? ?? "",
      index: (json['index'] as num?)?.toInt() ?? 0,
      intro: json['intro'] as String? ?? "",
      externalUrl: json['externalUrl'] as String? ?? "",
      data: json['data'],
      kind: json['kind'] == null
          ? BearRewardPartKind.video
          : BearRewardPart.kindFromJson(json['kind'] as String),
    );

Map<String, dynamic> _$BearRewardPartToJson(_BearRewardPart instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'index': instance.index,
      'intro': instance.intro,
      'externalUrl': instance.externalUrl,
      'data': instance.data,
      'kind': BearRewardPart.kindToJson(instance.kind),
    };
