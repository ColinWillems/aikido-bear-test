import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';
import 'package:tinycolor2/tinycolor2.dart';

/// Mock data for the cards in the two collections shipped in the BEAR app.
///
/// Set boundaries are determined by the locked card artwork colour groups:
///
/// GRRReatest Games (Yoyos) — 60 cards, 5 sets of 12/12/12/13/11:
///   winter_sports   01-12  (salmon/pink background)
///   water_sports    13-24  (grey/beige background)
///   ball_team       25-36  (olive/yellow background)
///   racket_combat   37-49  (orange/brown background)
///   athletics_gym   50-60  (gold/yellow background)
///
/// GRRReatest Games Xtreme (Splits) — 30 cards, 3 sets of 10:
///   All locked cards share one uniform background so the original
///   equal-thirds split (1-10 / 11-20 / 21-30) is kept.
class MockCardRepository<T, C> implements CardRepository<Card, CardContext> {
  static List<CardCollection> cardCollections = <CardCollection>[
    _grrreatestGamesCollection(),
    _grrreatestGamesXtremeCollection(),
  ];

  // -------------------------------------------------------------------------
  // GRRReatest Games (Yoyos) — 60 cards total
  // -------------------------------------------------------------------------

  static CardCollection _grrreatestGamesCollection() {
    return CardCollection(
      id: "grrreatest_games",
      numCards: 60,
      index: 1600,
      indexType: 1,
      unlockType: 0,
      cardRatio: 0.7,
      color: BearColors.bearOrange,
      title: "GRRReatest Games",
      sets: <CardSet>[
        // Winter Sports — global indices 01-12 (salmon/pink locked cards)
        CardSet(
          id: "winter_sports",
          color: TinyColor.fromString("9060A8").toColor(),
          index: 1,
          indexType: 1,
          numCards: 12,
          title: "Winter Sports",
          cards: const <Card>[
            Card(id: "TODO_GG_01", index: 1,  title: ""),                                   // 01 — locked only
            Card(id: "TODO_GG_02", index: 2,  title: "Ski Jumping",       hasFront: true),  // 02
            Card(id: "TODO_GG_03", index: 3,  title: "Curling",           hasFront: true),  // 03
            Card(id: "TODO_GG_04", index: 4,  title: "Figure Skating",    hasFront: true),  // 04
            Card(id: "TODO_GG_05", index: 5,  title: ""),                                   // 05 — locked only
            Card(id: "TODO_GG_06", index: 6,  title: "Speed Skating",     hasFront: true),  // 06
            Card(id: "TODO_GG_07", index: 7,  title: "Cross Country Ski", hasFront: true),  // 07
            Card(id: "TODO_GG_08", index: 8,  title: ""),                                   // 08 — locked only
            Card(id: "TODO_GG_09", index: 9,  title: "Luge",              hasFront: true),  // 09
            Card(id: "TODO_GG_10", index: 10, title: ""),                                   // 10 — locked only
            Card(id: "TODO_GG_11", index: 11, title: ""),                                   // 11 — locked only
            Card(id: "TODO_GG_12", index: 12, title: ""),                                   // 12 — locked only
          ],
        ),
        // Water Sports — global indices 13-24 (grey/beige locked cards)
        CardSet(
          id: "water_sports",
          color: TinyColor.fromString("60A8D8").toColor(),
          index: 2,
          indexType: 1,
          numCards: 12,
          title: "Water Sports",
          cards: const <Card>[
            Card(id: "TODO_GG_13", index: 1,  title: ""),                                   // 13 — locked only
            Card(id: "TODO_GG_14", index: 2,  title: "Surfing",           hasFront: true),  // 14
            Card(id: "TODO_GG_15", index: 3,  title: "Diving",            hasFront: true),  // 15
            Card(id: "TODO_GG_16", index: 4,  title: "Kayaking",          hasFront: true),  // 16
            Card(id: "TODO_GG_17", index: 5,  title: "Wind Surfing",      hasFront: true),  // 17
            Card(id: "TODO_GG_18", index: 6,  title: "Sailing",           hasFront: true),  // 18
            Card(id: "TODO_GG_19", index: 7,  title: "Water Polo",        hasFront: true),  // 19
            Card(id: "TODO_GG_20", index: 8,  title: ""),                                   // 20 — locked only
            Card(id: "TODO_GG_21", index: 9,  title: ""),                                   // 21 — locked only
            Card(id: "TODO_GG_22", index: 10, title: ""),                                   // 22 — locked only
            Card(id: "TODO_GG_23", index: 11, title: ""),                                   // 23 — locked only
            Card(id: "TODO_GG_24", index: 12, title: ""),                                   // 24 — locked only
          ],
        ),
        // Ball & Team — global indices 25-36 (olive/yellow locked cards)
        CardSet(
          id: "ball_team",
          color: TinyColor.fromString("78C030").toColor(),
          index: 3,
          indexType: 1,
          numCards: 12,
          title: "Ball & Team",
          cards: const <Card>[
            Card(id: "TODO_GG_25", index: 1,  title: ""),                                       // 25 — locked only
            Card(id: "TODO_GG_26", index: 2,  title: ""),                                       // 26 — locked only
            Card(id: "TODO_GG_27", index: 3,  title: "Baseball",           hasFront: true),     // 27
            Card(id: "TODO_GG_28", index: 4,  title: ""),                                       // 28 — locked only
            Card(id: "TODO_GG_29", index: 5,  title: "Basketball",         hasFront: true),     // 29
            Card(id: "TODO_GG_30", index: 6,  title: "Lacrosse",           hasFront: true),     // 30
            Card(id: "TODO_GG_31", index: 7,  title: "Rugby",              hasFront: true),     // 31
            Card(id: "TODO_GG_32", index: 8,  title: "Beach Volleyball",   hasFront: true),     // 32
            Card(id: "TODO_GG_33", index: 9,  title: "Handball",           hasFront: true),     // 33
            Card(id: "TODO_GG_34", index: 10, title: ""),                                       // 34 — locked only
            Card(id: "TODO_GG_35", index: 11, title: ""),                                       // 35 — locked only
            Card(id: "TODO_GG_36", index: 12, title: ""),                                       // 36 — locked only
          ],
        ),
        // Racket & Combat — global indices 37-45, 47-48, 50 (orange/red locked cards, H=81)
        CardSet(
          id: "racket_combat",
          color: TinyColor.fromString("D83030").toColor(),
          index: 4,
          indexType: 1,
          numCards: 12,
          title: "Racket & Combat",
          cards: const <Card>[
            Card(id: "TODO_GG_37", index: 1,  title: ""),                                   // 37 — locked only
            Card(id: "TODO_GG_38", index: 2,  title: ""),                                   // 38 — locked only
            Card(id: "TODO_GG_39", index: 3,  title: "Judo",              hasFront: true),  // 39
            Card(id: "TODO_GG_40", index: 4,  title: "Karate",            hasFront: true),  // 40
            Card(id: "TODO_GG_41", index: 5,  title: "Table Tennis",      hasFront: true),  // 41
            Card(id: "TODO_GG_42", index: 6,  title: ""),                                   // 42 — locked only
            Card(id: "TODO_GG_43", index: 7,  title: "Badminton",         hasFront: true),  // 43
            Card(id: "TODO_GG_44", index: 8,  title: ""),                                   // 44 — locked only
            Card(id: "TODO_GG_45", index: 9,  title: ""),                                   // 45 — locked only
            Card(id: "TODO_GG_47", index: 10, title: "Pickleball",        hasFront: true),  // 47
            Card(id: "TODO_GG_48", index: 11, title: ""),                                   // 48 — locked only
            Card(id: "TODO_GG_50", index: 12, title: "Golf",              hasFront: true),  // 50
          ],
        ),
        // Athletics & Gym — global indices 46, 49, 51-60 (gold/yellow locked cards, H=24)
        CardSet(
          id: "athletics_gym",
          color: TinyColor.fromString("F0D800").toColor(),
          index: 5,
          indexType: 1,
          numCards: 12,
          title: "Athletics & Gym",
          cards: const <Card>[
            Card(id: "TODO_GG_46", index: 1,  title: "Hurdles",           hasFront: true),  // 46
            Card(id: "TODO_GG_49", index: 2,  title: ""),                                   // 49 — locked only
            Card(id: "TODO_GG_51", index: 3,  title: "Weightlifting",     hasFront: true),  // 51
            Card(id: "TODO_GG_52", index: 4,  title: "Bouldering",        hasFront: true),  // 52
            Card(id: "TODO_GG_53", index: 5,  title: ""),                                   // 53 — locked only
            Card(id: "TODO_GG_54", index: 6,  title: "Marathon",          hasFront: true),  // 54
            Card(id: "TODO_GG_55", index: 7,  title: ""),                                   // 55 — locked only
            Card(id: "TODO_GG_56", index: 8,  title: "Long Jump",         hasFront: true),  // 56
            Card(id: "TODO_GG_57", index: 9,  title: ""),                                   // 57 — locked only
            Card(id: "TODO_GG_58", index: 10, title: ""),                                   // 58 — locked only
            Card(id: "TODO_GG_59", index: 11, title: "Gymnastics",        hasFront: true),  // 59
            Card(id: "TODO_GG_60", index: 12, title: ""),                                   // 60 — locked only
          ],
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // GRRReatest Games Xtreme (Splits) — 30 cards total
  // All locked cards share one uniform background; equal thirds kept.
  // -------------------------------------------------------------------------

  static CardCollection _grrreatestGamesXtremeCollection() {
    return CardCollection(
      id: "grrreatest_games_xtreme",
      numCards: 30,
      index: 3200,
      indexType: 1,
      unlockType: 0,
      cardRatio: 0.425,
      color: BearColors.bearAvatarPurple,
      title: "GRRReatest Games Xtreme",
      sets: <CardSet>[
        // Power & Precision — global indices 01-10
        CardSet(
          id: "power_precision",
          color: TinyColor.fromString("C0F000").toColor(),
          index: 1,
          indexType: 1,
          numCards: 10,
          title: "Power & Precision",
          cards: const <Card>[
            Card(id: "TODO_GGX_01", index: 1,  title: ""),                                        // 01 — locked only
            Card(id: "TODO_GGX_02", index: 2,  title: "Skateboarding",    hasFront: true),        // 02
            Card(id: "TODO_GGX_03", index: 3,  title: "Mountain Biking",  hasFront: true),        // 03
            Card(id: "TODO_GGX_04", index: 4,  title: ""),                                        // 04 — locked only
            Card(id: "TODO_GGX_05", index: 5,  title: ""),                                        // 05 — locked only
            Card(id: "TODO_GGX_06", index: 6,  title: ""),                                        // 06 — locked only
            Card(id: "TODO_GGX_07", index: 7,  title: "Breakdancing",     hasFront: true),        // 07
            Card(id: "TODO_GGX_08", index: 8,  title: "Soapbox Racing",   hasFront: true),        // 08
            Card(id: "TODO_GGX_09", index: 9,  title: ""),                                        // 09 — locked only
            Card(id: "TODO_GGX_10", index: 10, title: "Unicycling",       hasFront: true),        // 10
          ],
        ),
        // Wild Water — global indices 11-20
        CardSet(
          id: "wild_water",
          color: TinyColor.fromString("00B8D8").toColor(),
          index: 2,
          indexType: 1,
          numCards: 10,
          title: "Wild Water",
          cards: const <Card>[
            Card(id: "TODO_GGX_11", index: 1,  title: "Wakeboarding",        hasFront: true),     // 11
            Card(id: "TODO_GGX_12", index: 2,  title: "Water Skiing",        hasFront: true),     // 12
            Card(id: "TODO_GGX_13", index: 3,  title: ""),                                        // 13 — locked only
            Card(id: "TODO_GGX_14", index: 4,  title: ""),                                        // 14 — locked only
            Card(id: "TODO_GGX_15", index: 5,  title: "Whitewater Rafting",  hasFront: true),     // 15
            Card(id: "TODO_GGX_16", index: 6,  title: "Jet Skiing",          hasFront: true),     // 16
            Card(id: "TODO_GGX_17", index: 7,  title: "Hydro Flight",        hasFront: true),     // 17
            Card(id: "TODO_GGX_18", index: 8,  title: ""),                                        // 18 — locked only
            Card(id: "TODO_GGX_19", index: 9,  title: ""),                                        // 19 — locked only
            Card(id: "TODO_GGX_20", index: 10, title: ""),                                        // 20 — locked only
          ],
        ),
        // Extreme Heights — global indices 21-30
        CardSet(
          id: "extreme_heights",
          color: TinyColor.fromString("D80078").toColor(),
          index: 3,
          indexType: 1,
          numCards: 10,
          title: "Extreme Heights",
          cards: const <Card>[
            Card(id: "TODO_GGX_21", index: 1,  title: "Snowboarding",     hasFront: true),        // 21
            Card(id: "TODO_GGX_22", index: 2,  title: "Sandboarding",     hasFront: true),        // 22
            Card(id: "TODO_GGX_23", index: 3,  title: ""),                                        // 23 — locked only
            Card(id: "TODO_GGX_24", index: 4,  title: "Rock Climbing",    hasFront: true),        // 24
            Card(id: "TODO_GGX_25", index: 5,  title: ""),                                        // 25 — locked only
            Card(id: "TODO_GGX_26", index: 6,  title: "Sky Diving",       hasFront: true),        // 26
            Card(id: "TODO_GGX_27", index: 7,  title: "Bungee Jumping",   hasFront: true),        // 27
            Card(id: "TODO_GGX_28", index: 8,  title: ""),                                        // 28 — locked only
            Card(id: "TODO_GGX_29", index: 9,  title: ""),                                        // 29 — locked only
            Card(id: "TODO_GGX_30", index: 10, title: ""),                                        // 30 — locked only
          ],
        ),
      ],
    );
  }

  CardCollection? _getCardCollection(String collectionId) {
    return cardCollections
        .where((collection) => collection.id == collectionId)
        .firstOrNull;
  }

  CardSet? _getCardSet(String setId, String collectionId) {
    CardCollection? cardCollection = _getCardCollection(collectionId);

    if (cardCollection != null) {
      return cardCollection.sets.where((set) => set.id == setId).firstOrNull;
    }

    return null;
  }

  @override
  void add(card) async {
    throw UnimplementedError();
  }

  @override
  Future<Card?> get(String id, CardContext? context) async {
    if (context == null || context.setId == null) {
      throw const FormatException("A CardContext is required to get a Card");
    }

    CardSet? cardSet = _getCardSet(context.setId!, context.collectionId);

    if (cardSet != null) {
      return cardSet.cards.where((card) => card.id == id).firstOrNull;
    }

    return null;
  }

  @override
  Future<List<Card>> getAll(CardContext? context) async {
    List<Card> cards = <Card>[];
    if (context == null) {
      for (var cardCollection in cardCollections) {
        for (var set in cardCollection.sets) {
          cards.addAll(set.cards);
        }
      }
    } else if (context.setId != null) {
      CardSet? cardSet = _getCardSet(context.setId!, context.collectionId);

      if (cardSet != null) {
        cards = cardSet.cards.toList();
      }
    } else {
      CardCollection? cardCollection = _getCardCollection(context.collectionId);

      for (var set in cardCollection!.sets) {
        cards.addAll(set.cards);
      }
    }

    return cards;
  }

  @override
  void remove(card) async {
    throw UnimplementedError();
  }

  @override
  void update(card) async {
    throw UnimplementedError();
  }
}
