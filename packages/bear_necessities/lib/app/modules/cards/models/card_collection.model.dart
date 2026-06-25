import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart' hide DeepCollectionEquality;

part 'card_collection.model.freezed.dart';

part 'card_collection.model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
sealed class CardCollection with _$CardCollection {
  const CardCollection._();
  @JsonSerializable(explicitToJson: true)
  factory CardCollection({
    String id = "",
    int columns = 3,
    bool fullHeight = false,
    num cardRatio = 0.7,
    int unlockType = 0,
    int indexType = 0,
    bool useAnim = false,
    bool hasShowdown = false,
    int numCards = 0,
    int index = 0,
    @JsonKey(fromJson: ColorUtil.fromJson) Color color = BearColors.creamWhite,
    String title = "",
    List<CardSet> sets = const <CardSet>[],
  }) {
    final coll = _CardCollection(
        id: id,
        columns: columns,
        fullHeight: fullHeight,
        cardRatio: cardRatio,
        unlockType: unlockType,
        indexType: indexType,
        useAnim: useAnim,
        hasShowdown: hasShowdown,
        numCards: numCards,
        index: index,
        color: color,
        title: title,
        sets: <CardSet>[]);
    coll.replaceAllSets(sets);
    return coll;
  }
  /* const factory CardCollection({
    @Default("") String id,
    @Default(0) int columns,
    @Default(false) bool fullHeight,
    @Default(false) bool useAnim,
    @Default(false) bool hasShowdown,
    @Default(0.7) num cardRatio,
    @Default(0) int unlockType,
    @Default(0) int indexType,
    @Default(0) int numCards,
    @Default(0) int index,
    @JsonKey(fromJson: ColorUtil.fromJson, toJson: ColorUtil.toJson)
    @Default(BearColors.creamWhite)
    Color color,
    @Default("") String title,
    @JsonKey(ignore: true) @Default(<CardSet>[]) List<CardSet> sets,
  }) = _CardCollection; */

  @override
  String get id;
  @override
  int get columns;
  @override
  bool get fullHeight;
  @override
  bool get useAnim;
  @override
  bool get hasShowdown;
  @override
  num get cardRatio;
  @override
  int get unlockType;
  @override
  int get indexType;
  @override
  int get numCards;
  @override
  int get index;
  @override
  Color get color;
  @override
  String get title;
  @override
  List<CardSet> get sets;

  String get imagePath {
    return (id.isEmpty) ? "" : "images/cards/$id.png";
  }

  String get tileImagePath {
    return (id.isEmpty) ? "" : "images/cards/${id}_tile.png";
  }

  String get animationPath {
    return (id.isEmpty || !useAnim)
        ? ""
        : imagePath.replaceFirst(RegExp(r'\.png'), ".lottie");
  }

  String get unlockImagePath {
    return (id.isEmpty)
        ? ""
        : imagePath.replaceFirst(RegExp(r'\.png'), "_unlock.png");
  }

  bool get unlocked {
    int totalCardsInSets = 0;
    for (var set in sets) {
      if (!set.unlocked) {
        return false; // return early if any set has not been unlocked yet
      }
      totalCardsInSets += set.numCards;
    }

    return sets.isNotEmpty && (totalCardsInSets >= numCards);
  }

  bool get isEmpty {
    if (numCards > 0) {
      for (var set in sets) {
        if (set.numCards > 0) {
          return false; // return early if any set has not been unlocked yet
        }
      }
    }
    return true;
  }

  CardSet addSet(CardSet set) {
    final connectedSet = set.copyWithCollection(collection: this);
    sets.add(connectedSet);
    return connectedSet;
  }

  List<CardSet> addSets(List<CardSet> newSets) {
    final connectedSets =
        newSets.map((set) => set.copyWithCollection(collection: this));
    sets.addAll(connectedSets);
    return connectedSets.toList();
  }

  List<CardSet> replaceAllSets(List<CardSet> newSets) {
    final connectedSets =
        newSets.map((set) => set.copyWithCollection(collection: this));
    sets.assignAll(connectedSets);

    return connectedSets.toList();
  }

  factory CardCollection.fromJson(Map<String, dynamic> json) =>
      _$CardCollectionFromJson(json);
}

/*class CardCollection {
  late String id;
  late bool isDefault;
  late int index;
  late Color color;
  String get imagePath {
    return "images/cards/$id.png";
  }

  late String title;
  late List<CardSet> sets;

  CardCollection(
      {this.id = "",
      this.isDefault = false,
      this.index = 0,
      this.color = BearColors.creamWhite,
      this.title = "",
      this.sets = const <CardSet>[]}) {
    sets.assignAll(sets.map((set) => set.copyWith(collection: this)));
  }

  factory CardCollection.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['id'] == "") {
      throw FormatException(
          "CardCollection data id must not be null or empty", json);
    }

    var coll = collections[json['id']];
    if (coll == null) {
      coll = CardCollection(
        id: json['id'],
        isDefault: json['isDefault'],
        index: json['index'],
        color: TinyColor.fromString("#$json['color']").toColor(),
        title: json['title'],
      );
      collections[coll.id] = coll;
      coll.sets = (json['sets'] != null)
          ? (json['sets'] as List<dynamic>).map((v) {
              return CardSet.fromJson(v);
            }).toList()
          : <CardSet>[];
    }
    return coll;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['isDefault'] = isDefault;
    data['index'] = index;
    data['color'] = color.toString();
    data['title'] = title;
    data['sets'] = sets.map((v) => v.toJson()).toList();
    return data;
  }

  static final Map<String, CardCollection> collections = {};
}*/
