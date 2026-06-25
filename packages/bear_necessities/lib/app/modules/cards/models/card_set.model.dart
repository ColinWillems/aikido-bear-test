import 'package:bear_necessities/bear_necessities.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart' hide DeepCollectionEquality;

part 'card_set.model.freezed.dart';

part 'card_set.model.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
sealed class CardSet with _$CardSet {
  const CardSet._();
  factory CardSet({
    String id = "",
    int index = 0,
    int indexType = 0,
    String title = "",
    @JsonKey(fromJson: ColorUtil.fromJson) Color color = BearColors.creamWhite,
    int numCards = 0,
    @JsonKey(ignore: true) CardCollection? collection,
    @JsonKey(ignore: true) List<Card> cards = const <Card>[],
  }) {
    final set = _CardSet(
        id: id,
        index: index,
        indexType: indexType,
        title: title,
        color: color,
        numCards: numCards,
        collection: collection,
        cards: <Card>[]);
    set.replaceAllCards(cards);
    return set;
  }
  /* const factory CardSet({
    @Default("") String id,
    @Default(0) int index,
    @Default(0) int indexType,
    @Default("") String title,
    @JsonKey(fromJson: ColorUtil.fromJson, toJson: ColorUtil.toJson)
    @Default(BearColors.creamWhite)
    Color color,
    @Default(0) int numCards,
    @JsonKey(ignore: true) CardCollection? collection,
    @JsonKey(ignore: true) @Default(<Card>[]) List<Card> cards,
  }) = _CardSet; */

  @override
  String get id;
  @override
  int get index;
  @override
  int get indexType;
  @override
  String get title;
  @override
  Color get color;
  String get imagePath {
    return (collection == null || id.isEmpty)
        ? ""
        : "images/cards/${collection?.id}/$id.png";
  }

  /// Borderless variant of [imagePath], used as the header image on the
  /// set page (top of [CardSetView]). Falls back to [imagePath] when no
  /// dedicated header asset has been uploaded.
  String get headerImagePath {
    return (collection == null || id.isEmpty)
        ? ""
        : "images/cards/${collection?.id}/${id}_header.png";
  }

  String get unlockImagePath {
    return (collection == null || id.isEmpty)
        ? ""
        : imagePath.replaceFirst(RegExp(r'\.png'), "_unlock.png");
  }

  @override
  int get numCards;
  @override
  CardCollection? get collection;
  @override
  List<Card> get cards;

  /// Effectieve ratio voor dit set: gebruikt de collectie-ratio als fallback.
  num get effectiveCardRatio => collection?.cardRatio ?? 0.7;

  bool get unlocked {
    if (cards.length != numCards) {
      return false;
    }
    for (var card in cards) {
      if (!card.unlocked) {
        return false; // return early if any card has not been unlocked yet
      }
    }
    return true;
  }

  Card addCard(Card card) {
    final connectedCard = card.copyWith(set: this);
    cards.add(connectedCard);
    return connectedCard;
  }

  List<Card> addCards(List<Card> newCards) {
    final connectedCards = newCards.map((card) => card.copyWith(set: this));
    cards.addAll(connectedCards);
    return connectedCards.toList();
  }

  List<Card> replaceAllCards(List<Card> newCards) {
    final connectedCards = newCards.map((card) => card.copyWith(set: this));
    cards.assignAll(connectedCards);
    return connectedCards.toList();
  }

  factory CardSet.fromJson(Map<String, dynamic> json) =>
      _$CardSetFromJson(json);

  CardSet copyWithCollection({required CardCollection collection}) {
    return CardSet(
      id: id,
      index: index,
      indexType: indexType,
      title: title,
      color: color,
      numCards: numCards,
      cards: cards,
      collection: collection,
    );
  }
}
