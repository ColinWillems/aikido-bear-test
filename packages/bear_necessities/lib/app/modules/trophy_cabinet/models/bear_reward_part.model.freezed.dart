// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bear_reward_part.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BearRewardPart {
  String get id;
  String get name;
  int get index;
  String get intro;
  String get externalUrl;
  dynamic get data;
  @JsonKey(
      fromJson: BearRewardPart.kindFromJson, toJson: BearRewardPart.kindToJson)
  BearRewardPartKind get kind;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get completed;
  @JsonKey(includeFromJson: false, includeToJson: false)
  BearReward? get reward;

  /// Create a copy of BearRewardPart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BearRewardPartCopyWith<BearRewardPart> get copyWith =>
      _$BearRewardPartCopyWithImpl<BearRewardPart>(
          this as BearRewardPart, _$identity);

  /// Serializes this BearRewardPart to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BearRewardPart &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.intro, intro) || other.intro == intro) &&
            (identical(other.externalUrl, externalUrl) ||
                other.externalUrl == externalUrl) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.reward, reward) || other.reward == reward));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      index,
      intro,
      externalUrl,
      const DeepCollectionEquality().hash(data),
      kind,
      completed,
      reward);

  @override
  String toString() {
    return 'BearRewardPart(id: $id, name: $name, index: $index, intro: $intro, externalUrl: $externalUrl, data: $data, kind: $kind, completed: $completed, reward: $reward)';
  }
}

/// @nodoc
abstract mixin class $BearRewardPartCopyWith<$Res> {
  factory $BearRewardPartCopyWith(
          BearRewardPart value, $Res Function(BearRewardPart) _then) =
      _$BearRewardPartCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      int index,
      String intro,
      String externalUrl,
      dynamic data,
      @JsonKey(
          fromJson: BearRewardPart.kindFromJson,
          toJson: BearRewardPart.kindToJson)
      BearRewardPartKind kind,
      @JsonKey(includeFromJson: false, includeToJson: false) bool completed,
      @JsonKey(includeFromJson: false, includeToJson: false)
      BearReward? reward});

  $BearRewardCopyWith<$Res>? get reward;
}

/// @nodoc
class _$BearRewardPartCopyWithImpl<$Res>
    implements $BearRewardPartCopyWith<$Res> {
  _$BearRewardPartCopyWithImpl(this._self, this._then);

  final BearRewardPart _self;
  final $Res Function(BearRewardPart) _then;

  /// Create a copy of BearRewardPart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? index = null,
    Object? intro = null,
    Object? externalUrl = null,
    Object? data = freezed,
    Object? kind = null,
    Object? completed = null,
    Object? reward = freezed,
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
      intro: null == intro
          ? _self.intro
          : intro // ignore: cast_nullable_to_non_nullable
              as String,
      externalUrl: null == externalUrl
          ? _self.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as BearRewardPartKind,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      reward: freezed == reward
          ? _self.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as BearReward?,
    ));
  }

  /// Create a copy of BearRewardPart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BearRewardCopyWith<$Res>? get reward {
    if (_self.reward == null) {
      return null;
    }

    return $BearRewardCopyWith<$Res>(_self.reward!, (value) {
      return _then(_self.copyWith(reward: value));
    });
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BearRewardPart extends BearRewardPart {
  const _BearRewardPart(
      {this.id = "",
      this.name = "",
      this.index = 0,
      this.intro = "",
      this.externalUrl = "",
      this.data,
      @JsonKey(
          fromJson: BearRewardPart.kindFromJson,
          toJson: BearRewardPart.kindToJson)
      this.kind = BearRewardPartKind.video,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.completed = false,
      @JsonKey(includeFromJson: false, includeToJson: false) this.reward})
      : super._();
  factory _BearRewardPart.fromJson(Map<String, dynamic> json) =>
      _$BearRewardPartFromJson(json);

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
  @JsonKey()
  final String intro;
  @override
  @JsonKey()
  final String externalUrl;
  @override
  final dynamic data;
  @override
  @JsonKey(
      fromJson: BearRewardPart.kindFromJson, toJson: BearRewardPart.kindToJson)
  final BearRewardPartKind kind;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool completed;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final BearReward? reward;

  /// Create a copy of BearRewardPart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BearRewardPartCopyWith<_BearRewardPart> get copyWith =>
      __$BearRewardPartCopyWithImpl<_BearRewardPart>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BearRewardPartToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BearRewardPart &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.intro, intro) || other.intro == intro) &&
            (identical(other.externalUrl, externalUrl) ||
                other.externalUrl == externalUrl) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.reward, reward) || other.reward == reward));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      index,
      intro,
      externalUrl,
      const DeepCollectionEquality().hash(data),
      kind,
      completed,
      reward);

  @override
  String toString() {
    return 'BearRewardPart(id: $id, name: $name, index: $index, intro: $intro, externalUrl: $externalUrl, data: $data, kind: $kind, completed: $completed, reward: $reward)';
  }
}

/// @nodoc
abstract mixin class _$BearRewardPartCopyWith<$Res>
    implements $BearRewardPartCopyWith<$Res> {
  factory _$BearRewardPartCopyWith(
          _BearRewardPart value, $Res Function(_BearRewardPart) _then) =
      __$BearRewardPartCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      int index,
      String intro,
      String externalUrl,
      dynamic data,
      @JsonKey(
          fromJson: BearRewardPart.kindFromJson,
          toJson: BearRewardPart.kindToJson)
      BearRewardPartKind kind,
      @JsonKey(includeFromJson: false, includeToJson: false) bool completed,
      @JsonKey(includeFromJson: false, includeToJson: false)
      BearReward? reward});

  @override
  $BearRewardCopyWith<$Res>? get reward;
}

/// @nodoc
class __$BearRewardPartCopyWithImpl<$Res>
    implements _$BearRewardPartCopyWith<$Res> {
  __$BearRewardPartCopyWithImpl(this._self, this._then);

  final _BearRewardPart _self;
  final $Res Function(_BearRewardPart) _then;

  /// Create a copy of BearRewardPart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? index = null,
    Object? intro = null,
    Object? externalUrl = null,
    Object? data = freezed,
    Object? kind = null,
    Object? completed = null,
    Object? reward = freezed,
  }) {
    return _then(_BearRewardPart(
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
      intro: null == intro
          ? _self.intro
          : intro // ignore: cast_nullable_to_non_nullable
              as String,
      externalUrl: null == externalUrl
          ? _self.externalUrl
          : externalUrl // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as BearRewardPartKind,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      reward: freezed == reward
          ? _self.reward
          : reward // ignore: cast_nullable_to_non_nullable
              as BearReward?,
    ));
  }

  /// Create a copy of BearRewardPart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BearRewardCopyWith<$Res>? get reward {
    if (_self.reward == null) {
      return null;
    }

    return $BearRewardCopyWith<$Res>(_self.reward!, (value) {
      return _then(_self.copyWith(reward: value));
    });
  }
}

// dart format on
