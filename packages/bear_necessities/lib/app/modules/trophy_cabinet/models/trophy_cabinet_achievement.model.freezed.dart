// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trophy_cabinet_achievement.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrophyCabinetAchievement<T, R> implements DiagnosticableTreeMixin {
  @JsonKey(
      fromJson: TrophyCabinetAchievement.typeFromJson,
      toJson: TrophyCabinetAchievement.typeToJson)
  dynamic get type;
  String get id;
  @JsonKey(
      fromJson:
          TrophyCabinetAchievement.rewardTypeFromJson<TrophyCabinetRewardType>,
      toJson:
          TrophyCabinetAchievement.rewardTypeToJson<TrophyCabinetRewardType>)
  dynamic get rewardType;
  num get rewardAmount;
  DateTime get dateTime;

  /// Create a copy of TrophyCabinetAchievement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TrophyCabinetAchievementCopyWith<T, R, TrophyCabinetAchievement<T, R>>
      get copyWith => _$TrophyCabinetAchievementCopyWithImpl<T, R,
              TrophyCabinetAchievement<T, R>>(
          this as TrophyCabinetAchievement<T, R>, _$identity);

  /// Serializes this TrophyCabinetAchievement to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'TrophyCabinetAchievement<$T, $R>'))
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
            other is TrophyCabinetAchievement<T, R> &&
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
    return 'TrophyCabinetAchievement<$T, $R>(type: $type, id: $id, rewardType: $rewardType, rewardAmount: $rewardAmount, dateTime: $dateTime)';
  }
}

/// @nodoc
abstract mixin class $TrophyCabinetAchievementCopyWith<T, R, $Res> {
  factory $TrophyCabinetAchievementCopyWith(
          TrophyCabinetAchievement<T, R> value,
          $Res Function(TrophyCabinetAchievement<T, R>) _then) =
      _$TrophyCabinetAchievementCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(
          fromJson: TrophyCabinetAchievement.typeFromJson,
          toJson: TrophyCabinetAchievement.typeToJson)
      dynamic type,
      String id,
      @JsonKey(
          fromJson: TrophyCabinetAchievement
              .rewardTypeFromJson<TrophyCabinetRewardType>,
          toJson: TrophyCabinetAchievement
              .rewardTypeToJson<TrophyCabinetRewardType>)
      dynamic rewardType,
      num rewardAmount,
      DateTime dateTime});
}

/// @nodoc
class _$TrophyCabinetAchievementCopyWithImpl<T, R, $Res>
    implements $TrophyCabinetAchievementCopyWith<T, R, $Res> {
  _$TrophyCabinetAchievementCopyWithImpl(this._self, this._then);

  final TrophyCabinetAchievement<T, R> _self;
  final $Res Function(TrophyCabinetAchievement<T, R>) _then;

  /// Create a copy of TrophyCabinetAchievement
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
class _TrophyCabinetAchievement<T, R> extends TrophyCabinetAchievement<T, R>
    with DiagnosticableTreeMixin {
  const _TrophyCabinetAchievement(
      {@JsonKey(
          fromJson: TrophyCabinetAchievement.typeFromJson,
          toJson: TrophyCabinetAchievement.typeToJson)
      required this.type,
      required this.id,
      @JsonKey(
          fromJson: TrophyCabinetAchievement
              .rewardTypeFromJson<TrophyCabinetRewardType>,
          toJson: TrophyCabinetAchievement
              .rewardTypeToJson<TrophyCabinetRewardType>)
      required this.rewardType,
      required this.rewardAmount,
      required this.dateTime})
      : super._();
  factory _TrophyCabinetAchievement.fromJson(Map<String, dynamic> json) =>
      _$TrophyCabinetAchievementFromJson(json);

  @override
  @JsonKey(
      fromJson: TrophyCabinetAchievement.typeFromJson,
      toJson: TrophyCabinetAchievement.typeToJson)
  final dynamic type;
  @override
  final String id;
  @override
  @JsonKey(
      fromJson:
          TrophyCabinetAchievement.rewardTypeFromJson<TrophyCabinetRewardType>,
      toJson:
          TrophyCabinetAchievement.rewardTypeToJson<TrophyCabinetRewardType>)
  final dynamic rewardType;
  @override
  final num rewardAmount;
  @override
  final DateTime dateTime;

  /// Create a copy of TrophyCabinetAchievement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TrophyCabinetAchievementCopyWith<T, R, _TrophyCabinetAchievement<T, R>>
      get copyWith => __$TrophyCabinetAchievementCopyWithImpl<T, R,
          _TrophyCabinetAchievement<T, R>>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TrophyCabinetAchievementToJson<T, R>(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'TrophyCabinetAchievement<$T, $R>'))
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
            other is _TrophyCabinetAchievement<T, R> &&
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
    return 'TrophyCabinetAchievement<$T, $R>(type: $type, id: $id, rewardType: $rewardType, rewardAmount: $rewardAmount, dateTime: $dateTime)';
  }
}

/// @nodoc
abstract mixin class _$TrophyCabinetAchievementCopyWith<T, R, $Res>
    implements $TrophyCabinetAchievementCopyWith<T, R, $Res> {
  factory _$TrophyCabinetAchievementCopyWith(
          _TrophyCabinetAchievement<T, R> value,
          $Res Function(_TrophyCabinetAchievement<T, R>) _then) =
      __$TrophyCabinetAchievementCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(
          fromJson: TrophyCabinetAchievement.typeFromJson,
          toJson: TrophyCabinetAchievement.typeToJson)
      dynamic type,
      String id,
      @JsonKey(
          fromJson: TrophyCabinetAchievement
              .rewardTypeFromJson<TrophyCabinetRewardType>,
          toJson: TrophyCabinetAchievement
              .rewardTypeToJson<TrophyCabinetRewardType>)
      dynamic rewardType,
      num rewardAmount,
      DateTime dateTime});
}

/// @nodoc
class __$TrophyCabinetAchievementCopyWithImpl<T, R, $Res>
    implements _$TrophyCabinetAchievementCopyWith<T, R, $Res> {
  __$TrophyCabinetAchievementCopyWithImpl(this._self, this._then);

  final _TrophyCabinetAchievement<T, R> _self;
  final $Res Function(_TrophyCabinetAchievement<T, R>) _then;

  /// Create a copy of TrophyCabinetAchievement
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
    return _then(_TrophyCabinetAchievement<T, R>(
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
