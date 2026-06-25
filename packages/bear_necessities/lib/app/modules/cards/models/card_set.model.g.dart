// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_set.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CardSet _$CardSetFromJson(Map<String, dynamic> json) => _CardSet(
      id: json['id'] as String? ?? "",
      index: (json['index'] as num?)?.toInt() ?? 0,
      indexType: (json['indexType'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? "",
      color: json['color'] == null
          ? BearColors.creamWhite
          : ColorUtil.fromJson(json['color']),
      numCards: (json['numCards'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CardSetToJson(_CardSet instance) => <String, dynamic>{
      'id': instance.id,
      'index': instance.index,
      'indexType': instance.indexType,
      'title': instance.title,
      'color': ColorUtil.toJson(instance.color),
      'numCards': instance.numCards,
    };
