// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_achievement.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CardAchievement<T, R> implements DiagnosticableTreeMixin {
  @JsonKey(
      fromJson: CardAchievement.typeFromJson,
      toJson: CardAchievement.typeToJson)
  dynamic get type;
  String get id;
  @JsonKey(
      fromJson: CardAchievement.rewardTypeFromJson<CardRewardType>,
      toJson: CardAchievement.rewardTypeToJson<CardRewardType>)
  dynamic get rewardType;
  num get rewardAmount;
  DateTime get dateTime;

  /// Create a copy of CardAchievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CardAchievementCopyWith<T, R, CardAchievement<T, R>> get copyWith =>
      _$CardAchievementCopyWithImpl<T, R, CardAchievement<T, R>>(
          this as CardAchievement<T, R>, _$identity);

  /// Serializes this CardAchievement to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'CardAchievement<$T, $R>'))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('rewardType', rewardType))
      ..add(DiagnosticsProperty('rewardAmount', rewardAmount))
      ..add(DiagnosticsProperty('dateTime', dateTime));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CardAchievement<T, R> &&
            const DeepCollectionEquality().equals(other.type, type) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other.rewardType, rewardType) &&
            (identical(other.rewardAmount, rewardAmount) ||
                other.rewardAmount == rewardAmount) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      id,
      const DeepCollectionEquality().hash(rewardType),
      rewardAmount,
      dateTime);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CardAchievement<$T, $R>(type: $type, id: $id, rewardType: $rewardType, rewardAmount: $rewardAmount, dateTime: $dateTime)';
  }
}

/// @nodoc
abstract mixin class $CardAchievementCopyWith<T, R, $Res> {
  factory $CardAchievementCopyWith(CardAchievement<T, R> value,
          $Res Function(CardAchievement<T, R>) _then) =
      _$CardAchievementCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(
          fromJson: CardAchievement.typeFromJson,
          toJson: CardAchievement.typeToJson)
      dynamic type,
      String id,
      @JsonKey(
          fromJson: CardAchievement.rewardTypeFromJson<CardRewardType>,
          toJson: CardAchievement.rewardTypeToJson<CardRewardType>)
      dynamic rewardType,
      num rewardAmount,
      DateTime dateTime});
}

/// @nodoc
class _$CardAchievementCopyWithImpl<T, R, $Res>
    implements $CardAchievementCopyWith<T, R, $Res> {
  _$CardAchievementCopyWithImpl(this._self, this._then);

  final CardAchievement<T, R> _self;
  final $Res Function(CardAchievement<T, R>) _then;

  /// Create a copy of CardAchievement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? id = null,
    Object? rewardType = freezed,
    Object? rewardAmount = null,
    Object? dateTime = null,
  }) {
    return _then(_self.copyWith(
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as dynamic,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      rewardType: freezed == rewardType
          ? _self.rewardType
          : rewardType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      rewardAmount: null == rewardAmount
          ? _self.rewardAmount
          : rewardAmount // ignore: cast_nullable_to_non_nullable
              as num,
      dateTime: null == dateTime
          ? _self.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CardAchievement<T, R> extends CardAchievement<T, R>
    with DiagnosticableTreeMixin {
  const _CardAchievement(
      {@JsonKey(
          fromJson: CardAchievement.typeFromJson,
          toJson: CardAchievement.typeToJson)
      required this.type,
      required this.id,
      @JsonKey(
          fromJson: CardAchievement.rewardTypeFromJson<CardRewardType>,
          toJson: CardAchievement.rewardTypeToJson<CardRewardType>)
      required this.rewardType,
      required this.rewardAmount,
      required this.dateTime})
      : super._();
  factory _CardAchievement.fromJson(Map<String, dynamic> json) =>
      _$CardAchievementFromJson(json);

  @override
  @JsonKey(
      fromJson: CardAchievement.typeFromJson,
      toJson: CardAchievement.typeToJson)
  final dynamic type;
  @override
  final String id;
  @override
  @JsonKey(
      fromJson: CardAchievement.rewardTypeFromJson<CardRewardType>,
      toJson: CardAchievement.rewardTypeToJson<CardRewardType>)
  final dynamic rewardType;
  @override
  final num rewardAmount;
  @override
  final DateTime dateTime;

  /// Create a copy of CardAchievement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CardAchievementCopyWith<T, R, _CardAchievement<T, R>> get copyWith =>
      __$CardAchievementCopyWithImpl<T, R, _CardAchievement<T, R>>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CardAchievementToJson<T, R>(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'CardAchievement<$T, $R>'))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('rewardType', rewardType))
      ..add(DiagnosticsProperty('rewardAmount', rewardAmount))
      ..add(DiagnosticsProperty('dateTime', dateTime));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CardAchievement<T, R> &&
            const DeepCollectionEquality().equals(other.type, type) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other.rewardType, rewardType) &&
            (identical(other.rewardAmount, rewardAmount) ||
                other.rewardAmount == rewardAmount) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      id,
      const DeepCollectionEquality().hash(rewardType),
      rewardAmount,
      dateTime);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CardAchievement<$T, $R>(type: $type, id: $id, rewardType: $rewardType, rewardAmount: $rewardAmount, dateTime: $dateTime)';
  }
}

/// @nodoc
abstract mixin class _$CardAchievementCopyWith<T, R, $Res>
    implements $CardAchievementCopyWith<T, R, $Res> {
  factory _$CardAchievementCopyWith(_CardAchievement<T, R> value,
          $Res Function(_CardAchievement<T, R>) _then) =
      __$CardAchievementCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(
          fromJson: CardAchievement.typeFromJson,
          toJson: CardAchievement.typeToJson)
      dynamic type,
      String id,
      @JsonKey(
          fromJson: CardAchievement.rewardTypeFromJson<CardRewardType>,
          toJson: CardAchievement.rewardTypeToJson<CardRewardType>)
      dynamic rewardType,
      num rewardAmount,
      DateTime dateTime});
}

/// @nodoc
class __$CardAchievementCopyWithImpl<T, R, $Res>
    implements _$CardAchievementCopyWith<T, R, $Res> {
  __$CardAchievementCopyWithImpl(this._self, this._then);

  final _CardAchievement<T, R> _self;
  final $Res Function(_CardAchievement<T, R>) _then;

  /// Create a copy of CardAchievement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? type = freezed,
    Object? id = null,
    Object? rewardType = freezed,
    Object? rewardAmount = null,
    Object? dateTime = null,
  }) {
    return _then(_CardAchievement<T, R>(
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as dynamic,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      rewardType: freezed == rewardType
          ? _self.rewardType
          : rewardType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      rewardAmount: null == rewardAmount
          ? _self.rewardAmount
          : rewardAmount // ignore: cast_nullable_to_non_nullable
              as num,
      dateTime: null == dateTime
          ? _self.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
