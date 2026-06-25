// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Profile {
  String get id;
  String get name;
  int get index;
  @JsonKey(fromJson: ColorUtil.fromJson, toJson: Profile.colorToJson)
  Color get color;
  @JsonKey(
      fromJson: Profile.decorationsListFromJson,
      toJson: Profile.decorationsListToJson)
  List<ProfileDecoration> get decorations;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<Profile> get copyWith =>
      _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Profile &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality()
                .equals(other.decorations, decorations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, index, color,
      const DeepCollectionEquality().hash(decorations));

  @override
  String toString() {
    return 'Profile(id: $id, name: $name, index: $index, color: $color, decorations: $decorations)';
  }
}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) =
      _$ProfileCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      int index,
      @JsonKey(fromJson: ColorUtil.fromJson, toJson: Profile.colorToJson)
      Color color,
      @JsonKey(
          fromJson: Profile.decorationsListFromJson,
          toJson: Profile.decorationsListToJson)
      List<ProfileDecoration> decorations});
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res> implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? index = null,
    Object? color = null,
    Object? decorations = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      decorations: null == decorations
          ? _self.decorations
          : decorations // ignore: cast_nullable_to_non_nullable
              as List<ProfileDecoration>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Profile extends Profile {
  const _Profile(
      {this.id = Profiles.defaultId,
      this.name = "",
      this.index = 0,
      @JsonKey(fromJson: ColorUtil.fromJson, toJson: Profile.colorToJson)
      this.color = BearColors.bearAvatarBlue,
      @JsonKey(
          fromJson: Profile.decorationsListFromJson,
          toJson: Profile.decorationsListToJson)
      final List<ProfileDecoration> decorations = const <ProfileDecoration>[
        ProfileDecoration.baseballCap,
        ProfileDecoration.sunglasses
      ]})
      : _decorations = decorations,
        super._();
  factory _Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final int index;
  @override
  @JsonKey(fromJson: ColorUtil.fromJson, toJson: Profile.colorToJson)
  final Color color;
  final List<ProfileDecoration> _decorations;
  @override
  @JsonKey(
      fromJson: Profile.decorationsListFromJson,
      toJson: Profile.decorationsListToJson)
  List<ProfileDecoration> get decorations {
    if (_decorations is EqualUnmodifiableListView) return _decorations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_decorations);
  }

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfileCopyWith<_Profile> get copyWith =>
      __$ProfileCopyWithImpl<_Profile>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProfileToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Profile &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality()
                .equals(other._decorations, _decorations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, index, color,
      const DeepCollectionEquality().hash(_decorations));

  @override
  String toString() {
    return 'Profile(id: $id, name: $name, index: $index, color: $color, decorations: $decorations)';
  }
}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) =
      __$ProfileCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      int index,
      @JsonKey(fromJson: ColorUtil.fromJson, toJson: Profile.colorToJson)
      Color color,
      @JsonKey(
          fromJson: Profile.decorationsListFromJson,
          toJson: Profile.decorationsListToJson)
      List<ProfileDecoration> decorations});
}

/// @nodoc
class __$ProfileCopyWithImpl<$Res> implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? index = null,
    Object? color = null,
    Object? decorations = null,
  }) {
    return _then(_Profile(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      decorations: null == decorations
          ? _self._decorations
          : decorations // ignore: cast_nullable_to_non_nullable
              as List<ProfileDecoration>,
    ));
  }
}

// dart format on
