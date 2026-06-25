// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
      id: json['id'] as String? ?? Profiles.defaultId,
      name: json['name'] as String? ?? "",
      index: (json['index'] as num?)?.toInt() ?? 0,
      color: json['color'] == null
          ? BearColors.bearAvatarBlue
          : ColorUtil.fromJson(json['color']),
      decorations: json['decorations'] == null
          ? const <ProfileDecoration>[
              ProfileDecoration.baseballCap,
              ProfileDecoration.sunglasses
            ]
          : Profile.decorationsListFromJson(json['decorations']),
    );

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'index': instance.index,
      'color': Profile.colorToJson(instance.color),
      'decorations': Profile.decorationsListToJson(instance.decorations),
    };
