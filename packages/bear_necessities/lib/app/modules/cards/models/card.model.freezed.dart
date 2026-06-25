// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Card {
  String get id;
  int get index;
  String get title;
  bool get hasFront;
  @JsonKey(ignore: true)
  CardSet? get set;

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CardCopyWith<Card> get copyWith =>
      _$CardCopyWithImpl<Card>(this as Card, _$identity);

  /// Serializes this Card to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Card &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.hasFront, hasFront) ||
                other.hasFront == hasFront) &&
            (identical(other.set, set) || other.set == set));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, index, title, hasFront, set);

  @override
  String toString() {
    return 'Card(id: $id, index: $index, title: $title, hasFront: $hasFront, set: $set)';
  }
}

/// @nodoc
abstract mixin class $CardCopyWith<$Res> {
  factory $CardCopyWith(Card value, $Res Function(Card) _then) =
      _$CardCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      int index,
      String title,
      bool hasFront,
      @JsonKey(ignore: true) CardSet? set});

  $CardSetCopyWith<$Res>? get set;
}

/// @nodoc
class _$CardCopyWithImpl<$Res> implements $CardCopyWith<$Res> {
  _$CardCopyWithImpl(this._self, this._then);

  final Card _self;
  final $Res Function(Card) _then;

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? index = null,
    Object? title = null,
    Object? hasFront = null,
    Object? set = freezed,
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
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      hasFront: null == hasFront
          ? _self.hasFront
          : hasFront // ignore: cast_nullable_to_non_nullable
              as bool,
      set: freezed == set
          ? _self.set
          : set // ignore: cast_nullable_to_non_nullable
              as CardSet?,
    ));
  }

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CardSetCopyWith<$Res>? get set {
    if (_self.set == null) {
      return null;
    }

    return $CardSetCopyWith<$Res>(_self.set!, (value) {
      return _then(_self.copyWith(set: value));
    });
  }
}

/// Adds pattern-matching-related methods to [Card].
extension CardPatterns on Card {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Card value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Card() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Card value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Card():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Card value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Card() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, int index, String title, bool hasFront,
            @JsonKey(ignore: true) CardSet? set)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Card() when $default != null:
        return $default(
            _that.id, _that.index, _that.title, _that.hasFront, _that.set);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, int index, String title, bool hasFront,
            @JsonKey(ignore: true) CardSet? set)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Card():
        return $default(
            _that.id, _that.index, _that.title, _that.hasFront, _that.set);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, int index, String title, bool hasFront,
            @JsonKey(ignore: true) CardSet? set)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Card() when $default != null:
        return $default(
            _that.id, _that.index, _that.title, _that.hasFront, _that.set);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Card extends Card {
  const _Card(
      {this.id = Card.lockedId,
      this.index = 99999,
      this.title = "Locked",
      this.hasFront = false,
      @JsonKey(ignore: true) this.set})
      : super._();
  factory _Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final int index;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final bool hasFront;
  @override
  @JsonKey(ignore: true)
  final CardSet? set;

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CardCopyWith<_Card> get copyWith =>
      __$CardCopyWithImpl<_Card>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CardToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Card &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.hasFront, hasFront) ||
                other.hasFront == hasFront) &&
            (identical(other.set, set) || other.set == set));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, index, title, hasFront, set);

  @override
  String toString() {
    return 'Card(id: $id, index: $index, title: $title, hasFront: $hasFront, set: $set)';
  }
}

/// @nodoc
abstract mixin class _$CardCopyWith<$Res> implements $CardCopyWith<$Res> {
  factory _$CardCopyWith(_Card value, $Res Function(_Card) _then) =
      __$CardCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      int index,
      String title,
      bool hasFront,
      @JsonKey(ignore: true) CardSet? set});

  @override
  $CardSetCopyWith<$Res>? get set;
}

/// @nodoc
class __$CardCopyWithImpl<$Res> implements _$CardCopyWith<$Res> {
  __$CardCopyWithImpl(this._self, this._then);

  final _Card _self;
  final $Res Function(_Card) _then;

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? index = null,
    Object? title = null,
    Object? hasFront = null,
    Object? set = freezed,
  }) {
    return _then(_Card(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      hasFront: null == hasFront
          ? _self.hasFront
          : hasFront // ignore: cast_nullable_to_non_nullable
              as bool,
      set: freezed == set
          ? _self.set
          : set // ignore: cast_nullable_to_non_nullable
              as CardSet?,
    ));
  }

  /// Create a copy of Card
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CardSetCopyWith<$Res>? get set {
    if (_self.set == null) {
      return null;
    }

    return $CardSetCopyWith<$Res>(_self.set!, (value) {
      return _then(_self.copyWith(set: value));
    });
  }
}

// dart format on
