// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_collection.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CardCollection _$CardCollectionFromJson(Map<String, dynamic> json) =>
    _CardCollection(
      id: json['id'] as String? ?? "",
      columns: (json['columns'] as num?)?.toInt() ?? 0,
      fullHeight: json['fullHeight'] as bool? ?? false,
      useAnim: json['useAnim'] as bool? ?? false,
      hasShowdown: json['hasShowdown'] as bool? ?? false,
      cardRatio: json['cardRatio'] as num? ?? 0.7,
      unlockType: (json['unlockType'] as num?)?.toInt() ?? 0,
      indexType: (json['indexType'] as num?)?.toInt() ?? 0,
      numCards: (json['numCards'] as num?)?.toInt() ?? 0,
      index: (json['index'] as num?)?.toInt() ?? 0,
      color: json['color'] == null
          ? BearColors.creamWhite
          : ColorUtil.fromJson(json['color']),
      title: json['title'] as String? ?? "",
    );

Map<String, dynamic> _$CardCollectionToJson(_CardCollection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'columns': instance.columns,
      'fullHeight': instance.fullHeight,
      'useAnim': instance.useAnim,
      'hasShowdown': instance.hasShowdown,
      'cardRatio': instance.cardRatio,
      'unlockType': instance.unlockType,
      'indexType': instance.indexType,
      'numCards': instance.numCards,
      'index': instance.index,
      'color': ColorUtil.toJson(instance.color),
      'title': instance.title,
    };
