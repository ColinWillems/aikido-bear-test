// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_set.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CardSet {
  String get id;
  int get index;
  int get indexType;
  String get title;
  @JsonKey(fromJson: ColorUtil.fromJson, toJson: ColorUtil.toJson)
  Color get color;
  int get numCards;
  @JsonKey(ignore: true)
  CardCollection? get collection;
  @JsonKey(ignore: true)
  List<Card> get cards;

  /// Create a copy of CardSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CardSetCopyWith<CardSet> get copyWith =>
      _$CardSetCopyWithImpl<CardSet>(this as CardSet, _$identity);

  /// Serializes this CardSet to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CardSet &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.indexType, indexType) ||
                other.indexType == indexType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.numCards, numCards) ||
                other.numCards == numCards) &&
            (identical(other.collection, collection) ||
                other.collection == collection) &&
            const DeepCollectionEquality().equals(other.cards, cards));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, index, indexType, title,
      color, numCards, collection, const DeepCollectionEquality().hash(cards));

  @override
  String toString() {
    return 'CardSet(id: $id, index: $index, indexType: $indexType, title: $title, color: $color, numCards: $numCards, collection: $collection, cards: $cards)';
  }
}

/// @nodoc
abstract mixin class $CardSetCopyWith<$Res> {
  factory $CardSetCopyWith(CardSet value, $Res Function(CardSet) _then) =
      _$CardSetCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      int index,
      int indexType,
      String title,
      @JsonKey(fromJson: ColorUtil.fromJson, toJson: ColorUtil.toJson)
      Color color,
      int numCards,
      @JsonKey(ignore: true) CardCollection? collection,
      @JsonKey(ignore: true) List<Card> cards});

  $CardCollectionCopyWith<$Res>? get collection;
}

/// @nodoc
class _$CardSetCopyWithImpl<$Res> implements $CardSetCopyWith<$Res> {
  _$CardSetCopyWithImpl(this._self, this._then);

  final CardSet _self;
  final $Res Function(CardSet) _then;

  /// Create a copy of CardSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? index = null,
    Object? indexType = null,
    Object? title = null,
    Object? color = null,
    Object? numCards = null,
    Object? collection = freezed,
    Object? cards = null,
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
      indexType: null == indexType
          ? _self.indexType
          : indexType // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      numCards: null == numCards
          ? _self.numCards
          : numCards // ignore: cast_nullable_to_non_nullable
              as int,
      collection: freezed == collection
          ? _self.collection
          : collection // ignore: cast_nullable_to_non_nullable
              as CardCollection?,
      cards: null == cards
          ? _self.cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<Card>,
    ));
  }

  /// Create a copy of CardSet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CardCollectionCopyWith<$Res>? get collection {
    if (_self.collection == null) {
      return null;
    }

    return $CardCollectionCopyWith<$Res>(_self.collection!, (value) {
      return _then(_self.copyWith(collection: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _CardSet extends CardSet {
  const _CardSet(
      {this.id = "",
      this.index = 0,
      this.indexType = 0,
      this.title = "",
      @JsonKey(fromJson: ColorUtil.fromJson, toJson: ColorUtil.toJson)
      this.color = BearColors.creamWhite,
      this.numCards = 0,
      @JsonKey(ignore: true) this.collection,
      @JsonKey(ignore: true) this.cards = const <Card>[]})
      : super._();
  factory _CardSet.fromJson(Map<String, dynamic> json) =>
      _$CardSetFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final int index;
  @override
  @JsonKey()
  final int indexType;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey(fromJson: ColorUtil.fromJson, toJson: ColorUtil.toJson)
  final Color color;
  @override
  @JsonKey()
  final int numCards;
  @override
  @JsonKey(ignore: true)
  final CardCollection? collection;
  @override
  @JsonKey(ignore: true)
  final List<Card> cards;

  /// Create a copy of CardSet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CardSetCopyWith<_CardSet> get copyWith =>
      __$CardSetCopyWithImpl<_CardSet>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CardSetToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CardSet &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.indexType, indexType) ||
                other.indexType == indexType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.numCards, numCards) ||
                other.numCards == numCards) &&
            (identical(other.collection, collection) ||
                other.collection == collection) &&
            const DeepCollectionEquality().equals(other.cards, cards));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, index, indexType, title,
      color, numCards, collection, const DeepCollectionEquality().hash(cards));

  @override
  String toString() {
    return 'CardSet(id: $id, index: $index, indexType: $indexType, title: $title, color: $color, numCards: $numCards, collection: $collection, cards: $cards)';
  }
}

/// @nodoc
abstract mixin class _$CardSetCopyWith<$Res> implements $CardSetCopyWith<$Res> {
  factory _$CardSetCopyWith(_CardSet value, $Res Function(_CardSet) _then) =
      __$CardSetCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      int index,
      int indexType,
      String title,
      @JsonKey(fromJson: ColorUtil.fromJson, toJson: ColorUtil.toJson)
      Color color,
      int numCards,
      @JsonKey(ignore: true) CardCollection? collection,
      @JsonKey(ignore: true) List<Card> cards});

  @override
  $CardCollectionCopyWith<$Res>? get collection;
}

/// @nodoc
class __$CardSetCopyWithImpl<$Res> implements _$CardSetCopyWith<$Res> {
  __$CardSetCopyWithImpl(this._self, this._then);

  final _CardSet _self;
  final $Res Function(_CardSet) _then;

  /// Create a copy of CardSet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? index = null,
    Object? indexType = null,
    Object? title = null,
    Object? color = null,
    Object? numCards = null,
    Object? collection = freezed,
    Object? cards = null,
  }) {
    return _then(_CardSet(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      indexType: null == indexType
          ? _self.indexType
          : indexType // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      numCards: null == numCards
          ? _self.numCards
          : numCards // ignore: cast_nullable_to_non_nullable
              as int,
      collection: freezed == collection
          ? _self.collection
          : collection // ignore: cast_nullable_to_non_nullable
              as CardCollection?,
      cards: null == cards
          ? _self.cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<Card>,
    ));
  }

  /// Create a copy of CardSet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CardCollectionCopyWith<$Res>? get collection {
    if (_self.collection == null) {
      return null;
    }

    return $CardCollectionCopyWith<$Res>(_self.collection!, (value) {
      return _then(_self.copyWith(collection: value));
    });
  }
}

// dart format on
