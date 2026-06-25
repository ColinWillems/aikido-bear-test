// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_collection.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CardCollection {
  String get id;
  int get columns;
  bool get fullHeight;
  bool get useAnim;
  bool get hasShowdown;
  num get cardRatio;
  int get unlockType;
  int get indexType;
  int get numCards;
  int get index;
  @JsonKey(fromJson: ColorUtil.fromJson, toJson: ColorUtil.toJson)
  Color get color;
  String get title;
  @JsonKey(ignore: true)
  List<CardSet> get sets;

  /// Create a copy of CardCollection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CardCollectionCopyWith<CardCollection> get copyWith =>
      _$CardCollectionCopyWithImpl<CardCollection>(
          this as CardCollection, _$identity);

  /// Serializes this CardCollection to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CardCollection &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.columns, columns) || other.columns == columns) &&
            (identical(other.fullHeight, fullHeight) ||
                other.fullHeight == fullHeight) &&
            (identical(other.useAnim, useAnim) || other.useAnim == useAnim) &&
            (identical(other.hasShowdown, hasShowdown) ||
                other.hasShowdown == hasShowdown) &&
            (identical(other.cardRatio, cardRatio) ||
                other.cardRatio == cardRatio) &&
            (identical(other.unlockType, unlockType) ||
                other.unlockType == unlockType) &&
            (identical(other.indexType, indexType) ||
                other.indexType == indexType) &&
            (identical(other.numCards, numCards) ||
                other.numCards == numCards) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other.sets, sets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      columns,
      fullHeight,
      useAnim,
      hasShowdown,
      cardRatio,
      unlockType,
      indexType,
      numCards,
      index,
      color,
      title,
      const DeepCollectionEquality().hash(sets));

  @override
  String toString() {
    return 'CardCollection(id: $id, columns: $columns, fullHeight: $fullHeight, useAnim: $useAnim, hasShowdown: $hasShowdown, cardRatio: $cardRatio, unlockType: $unlockType, indexType: $indexType, numCards: $numCards, index: $index, color: $color, title: $title, sets: $sets)';
  }
}

/// @nodoc
abstract mixin class $CardCollectionCopyWith<$Res> {
  factory $CardCollectionCopyWith(
          CardCollection value, $Res Function(CardCollection) _then) =
      _$CardCollectionCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      int columns,
      bool fullHeight,
      bool useAnim,
      bool hasShowdown,
      num cardRatio,
      int unlockType,
      int indexType,
      int numCards,
      int index,
      @JsonKey(fromJson: ColorUtil.fromJson, toJson: ColorUtil.toJson)
      Color color,
      String title,
      @JsonKey(ignore: true) List<CardSet> sets});
}

/// @nodoc
class _$CardCollectionCopyWithImpl<$Res>
    implements $CardCollectionCopyWith<$Res> {
  _$CardCollectionCopyWithImpl(this._self, this._then);

  final CardCollection _self;
  final $Res Function(CardCollection) _then;

  /// Create a copy of CardCollection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? columns = null,
    Object? fullHeight = null,
    Object? useAnim = null,
    Object? hasShowdown = null,
    Object? cardRatio = null,
    Object? unlockType = null,
    Object? indexType = null,
    Object? numCards = null,
    Object? index = null,
    Object? color = null,
    Object? title = null,
    Object? sets = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      columns: null == columns
          ? _self.columns
          : columns // ignore: cast_nullable_to_non_nullable
              as int,
      fullHeight: null == fullHeight
          ? _self.fullHeight
          : fullHeight // ignore: cast_nullable_to_non_nullable
              as bool,
      useAnim: null == useAnim
          ? _self.useAnim
          : useAnim // ignore: cast_nullable_to_non_nullable
              as bool,
      hasShowdown: null == hasShowdown
          ? _self.hasShowdown
          : hasShowdown // ignore: cast_nullable_to_non_nullable
              as bool,
      cardRatio: null == cardRatio
          ? _self.cardRatio
          : cardRatio // ignore: cast_nullable_to_non_nullable
              as num,
      unlockType: null == unlockType
          ? _self.unlockType
          : unlockType // ignore: cast_nullable_to_non_nullable
              as int,
      indexType: null == indexType
          ? _self.indexType
          : indexType // ignore: cast_nullable_to_non_nullable
              as int,
      numCards: null == numCards
          ? _self.numCards
          : numCards // ignore: cast_nullable_to_non_nullable
              as int,
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      sets: null == sets
          ? _self.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<CardSet>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CardCollection extends CardCollection {
  const _CardCollection(
      {this.id = "",
      this.columns = 0,
      this.fullHeight = false,
      this.useAnim = false,
      this.hasShowdown = false,
      this.cardRatio = 0.7,
      this.unlockType = 0,
      this.indexType = 0,
      this.numCards = 0,
      this.index = 0,
      @JsonKey(fromJson: ColorUtil.fromJson, toJson: ColorUtil.toJson)
      this.color = BearColors.creamWhite,
      this.title = "",
      @JsonKey(ignore: true) this.sets = const <CardSet>[]})
      : super._();
  factory _CardCollection.fromJson(Map<String, dynamic> json) =>
      _$CardCollectionFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final int columns;
  @override
  @JsonKey()
  final bool fullHeight;
  @override
  @JsonKey()
  final bool useAnim;
  @override
  @JsonKey()
  final bool hasShowdown;
  @override
  @JsonKey()
  final num cardRatio;
  @override
  @JsonKey()
  final int unlockType;
  @override
  @JsonKey()
  final int indexType;
  @override
  @JsonKey()
  final int numCards;
  @override
  @JsonKey()
  final int index;
  @override
  @JsonKey(fromJson: ColorUtil.fromJson, toJson: ColorUtil.toJson)
  final Color color;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey(ignore: true)
  final List<CardSet> sets;

  /// Create a copy of CardCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CardCollectionCopyWith<_CardCollection> get copyWith =>
      __$CardCollectionCopyWithImpl<_CardCollection>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CardCollectionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CardCollection &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.columns, columns) || other.columns == columns) &&
            (identical(other.fullHeight, fullHeight) ||
                other.fullHeight == fullHeight) &&
            (identical(other.useAnim, useAnim) || other.useAnim == useAnim) &&
            (identical(other.hasShowdown, hasShowdown) ||
                other.hasShowdown == hasShowdown) &&
            (identical(other.cardRatio, cardRatio) ||
                other.cardRatio == cardRatio) &&
            (identical(other.unlockType, unlockType) ||
                other.unlockType == unlockType) &&
            (identical(other.indexType, indexType) ||
                other.indexType == indexType) &&
            (identical(other.numCards, numCards) ||
                other.numCards == numCards) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other.sets, sets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      columns,
      fullHeight,
      useAnim,
      hasShowdown,
      cardRatio,
      unlockType,
      indexType,
      numCards,
      index,
      color,
      title,
      const DeepCollectionEquality().hash(sets));

  @override
  String toString() {
    return 'CardCollection(id: $id, columns: $columns, fullHeight: $fullHeight, useAnim: $useAnim, hasShowdown: $hasShowdown, cardRatio: $cardRatio, unlockType: $unlockType, indexType: $indexType, numCards: $numCards, index: $index, color: $color, title: $title, sets: $sets)';
  }
}

/// @nodoc
abstract mixin class _$CardCollectionCopyWith<$Res>
    implements $CardCollectionCopyWith<$Res> {
  factory _$CardCollectionCopyWith(
          _CardCollection value, $Res Function(_CardCollection) _then) =
      __$CardCollectionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      int columns,
      bool fullHeight,
      bool useAnim,
      bool hasShowdown,
      num cardRatio,
      int unlockType,
      int indexType,
      int numCards,
      int index,
      @JsonKey(fromJson: ColorUtil.fromJson, toJson: ColorUtil.toJson)
      Color color,
      String title,
      @JsonKey(ignore: true) List<CardSet> sets});
}

/// @nodoc
class __$CardCollectionCopyWithImpl<$Res>
    implements _$CardCollectionCopyWith<$Res> {
  __$CardCollectionCopyWithImpl(this._self, this._then);

  final _CardCollection _self;
  final $Res Function(_CardCollection) _then;

  /// Create a copy of CardCollection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? columns = null,
    Object? fullHeight = null,
    Object? useAnim = null,
    Object? hasShowdown = null,
    Object? cardRatio = null,
    Object? unlockType = null,
    Object? indexType = null,
    Object? numCards = null,
    Object? index = null,
    Object? color = null,
    Object? title = null,
    Object? sets = null,
  }) {
    return _then(_CardCollection(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      columns: null == columns
          ? _self.columns
          : columns // ignore: cast_nullable_to_non_nullable
              as int,
      fullHeight: null == fullHeight
          ? _self.fullHeight
          : fullHeight // ignore: cast_nullable_to_non_nullable
              as bool,
      useAnim: null == useAnim
          ? _self.useAnim
          : useAnim // ignore: cast_nullable_to_non_nullable
              as bool,
      hasShowdown: null == hasShowdown
          ? _self.hasShowdown
          : hasShowdown // ignore: cast_nullable_to_non_nullable
              as bool,
      cardRatio: null == cardRatio
          ? _self.cardRatio
          : cardRatio // ignore: cast_nullable_to_non_nullable
              as num,
      unlockType: null == unlockType
          ? _self.unlockType
          : unlockType // ignore: cast_nullable_to_non_nullable
              as int,
      indexType: null == indexType
          ? _self.indexType
          : indexType // ignore: cast_nullable_to_non_nullable
              as int,
      numCards: null == numCards
          ? _self.numCards
          : numCards // ignore: cast_nullable_to_non_nullable
              as int,
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      sets: null == sets
          ? _self.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<CardSet>,
    ));
  }
}

// dart format on
