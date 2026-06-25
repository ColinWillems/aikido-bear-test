// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Card _$CardFromJson(Map<String, dynamic> json) => _Card(
      id: json['id'] as String? ?? Card.lockedId,
      index: (json['index'] as num?)?.toInt() ?? 99999,
      title: json['title'] as String? ?? "Locked",
      hasFront: json['hasFront'] as bool? ?? false,
    );

Map<String, dynamic> _$CardToJson(_Card instance) => <String, dynamic>{
      'id': instance.id,
      'index': instance.index,
      'title': instance.title,
      'hasFront': instance.hasFront,
    };
