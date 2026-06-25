// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bear_reward.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BearReward {
  String get id;
  int get index;
  String get name;
  BearRewardKind get kind;
  String get intro;
  String get outro;
  List<BearRewardPart> get parts;

  /// Create a copy of BearReward
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BearRewardCopyWith<BearReward> get copyWith =>
      _$BearRewardCopyWithImpl<BearReward>(this as BearReward, _$identity);

  /// Serializes this BearReward to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BearReward &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.intro, intro) || other.intro == intro) &&
            (identical(other.outro, outro) || other.outro == outro) &&
            const DeepCollectionEquality().equals(other.parts, parts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, index, name, kind, intro,
      outro, const DeepCollectionEquality().hash(parts));

  @override
  String toString() {
    return 'BearReward(id: $id, index: $index, name: $name, kind: $kind, intro: $intro, outro: $outro, parts: $parts)';
  }
}

/// @nodoc
abstract mixin class $BearRewardCopyWith<$Res> {
  factory $BearRewardCopyWith(
          BearReward value, $Res Function(BearReward) _then) =
      _$BearRewardCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      int index,
      String name,
      BearRewardKind kind,
      String intro,
      String outro,
      List<BearRewardPart> parts});
}

/// @nodoc
class _$BearRewardCopyWithImpl<$Res> implements $BearRewardCopyWith<$Res> {
  _$BearRewardCopyWithImpl(this._self, this._then);

  final BearReward _self;
  final $Res Function(BearReward) _then;

  /// Create a copy of BearReward
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? index = null,
    Object? name = null,
    Object? kind = null,
    Object? intro = null,
    Object? outro = null,
    Object? parts = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as BearRewardKind,
      intro: null == intro
          ? _self.intro
          : intro // ignore: cast_nullable_to_non_nullable
              as String,
      outro: null == outro
          ? _self.outro
          : outro // ignore: cast_nullable_to_non_nullable
              as String,
      parts: null == parts
          ? _self.parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<BearRewardPart>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BearReward extends BearReward {
  const _BearReward(
      {this.id = TrophyCabinet.defaultRewardId,
      this.index = 0,
      this.name = "",
      this.kind = BearRewardKind.cardCollection,
      this.intro = "",
      this.outro = "",
      this.parts = const <BearRewardPart>[]})
      : super._();
  factory _BearReward.fromJson(Map<String, dynamic> json) =>
      _$BearRewardFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final int index;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final BearRewardKind kind;
  @override
  @JsonKey()
  final String intro;
  @override
  @JsonKey()
  final String outro;
  @override
  @JsonKey()
  final List<BearRewardPart> parts;

  /// Create a copy of BearReward
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BearRewardCopyWith<_BearReward> get copyWith =>
      __$BearRewardCopyWithImpl<_BearReward>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BearRewardToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BearReward &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.intro, intro) || other.intro == intro) &&
            (identical(other.outro, outro) || other.outro == outro) &&
            const DeepCollectionEquality().equals(other.parts, parts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, index, name, kind, intro,
      outro, const DeepCollectionEquality().hash(parts));

  @override
  String toString() {
    return 'BearReward(id: $id, index: $index, name: $name, kind: $kind, intro: $intro, outro: $outro, parts: $parts)';
  }
}

/// @nodoc
abstract mixin class _$BearRewardCopyWith<$Res>
    implements $BearRewardCopyWith<$Res> {
  factory _$BearRewardCopyWith(
          _BearReward value, $Res Function(_BearReward) _then) =
      __$BearRewardCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      int index,
      String name,
      BearRewardKind kind,
      String intro,
      String outro,
      List<BearRewardPart> parts});
}

/// @nodoc
class __$BearRewardCopyWithImpl<$Res> implements _$BearRewardCopyWith<$Res> {
  __$BearRewardCopyWithImpl(this._self, this._then);

  final _BearReward _self;
  final $Res Function(_BearReward) _then;

  /// Create a copy of BearReward
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? index = null,
    Object? name = null,
    Object? kind = null,
    Object? intro = null,
    Object? outro = null,
    Object? parts = null,
  }) {
    return _then(_BearReward(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as BearRewardKind,
      intro: null == intro
          ? _self.intro
          : intro // ignore: cast_nullable_to_non_nullable
              as String,
      outro: null == outro
          ? _self.outro
          : outro // ignore: cast_nullable_to_non_nullable
              as String,
      parts: null == parts
          ? _self.parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<BearRewardPart>,
    ));
  }
}

// dart format on
