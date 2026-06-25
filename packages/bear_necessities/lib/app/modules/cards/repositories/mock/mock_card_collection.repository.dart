import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';
import 'package:tinycolor2/tinycolor2.dart';

/// Mock data for the two card collections shipped in the BEAR app:
///   - "grrreatest_games"        => GRRReatest Games (Yoyos)
///   - "grrreatest_games_xtreme" => GRRReatest Games Xtreme (Splits)
///
/// This mock repository is also used in production builds (see main.dart).
///
/// Notes:
///   * Card IDs are TODO placeholders (`TODO_GG_NN`, `TODO_GGX_NN`). Replace
///     them with the real QR-code IDs once available, AND rename the matching
///     image files in Firebase Storage (`images/cards/{collection}/{set}/...`).
///   * Set/card colors are sampled from the delivered category icon images;
///     they may need to be aligned with the official brand palette.
///   * `numCards` per set reflects the total number of locked card images
///     delivered. Cards without a front image are shown as locked placeholders.
class MockCardCollectionRepository<T, C>
    implements CardCollectionRepository<CardCollection, CardCollectionContext> {
  static List<CardCollection> get cardCollections {
    return <CardCollection>[
      _grrreatestGamesCollection(),
      _grrreatestGamesXtremeCollection(),
    ];
  }

  static CardCollection _grrreatestGamesCollection() {
    return CardCollection(
      id: "grrreatest_games",
      numCards: 60,
      index: 1600,
      indexType: 1, // sets number their cards 1..N internally
      unlockType: 0,
      cardRatio: 0.7,
      color: BearColors.bearOrange,
      title: "GRRReatest Games",
      sets: <CardSet>[
        CardSet(
          id: "winter_sports",
          color: TinyColor.fromString("9060A8").toColor(),
          index: 1,
          indexType: 1,
          numCards: 12,
          title: "Winter Sports",
        ),
        CardSet(
          id: "water_sports",
          color: TinyColor.fromString("60A8D8").toColor(),
          index: 2,
          indexType: 1,
          numCards: 12,
          title: "Water Sports",
        ),
        CardSet(
          id: "ball_team",
          color: TinyColor.fromString("78C030").toColor(),
          index: 3,
          indexType: 1,
          numCards: 12,
          title: "Ball & Team",
        ),
        CardSet(
          id: "racket_combat",
          color: TinyColor.fromString("D83030").toColor(),
          index: 4,
          indexType: 1,
          numCards: 12,
          title: "Racket & Combat",
        ),
        CardSet(
          id: "athletics_gym",
          color: TinyColor.fromString("F0D800").toColor(),
          index: 5,
          indexType: 1,
          numCards: 12,
          title: "Athletics & Gym",
        ),
      ],
    );
  }

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
        CardSet(
          id: "power_precision",
          color: TinyColor.fromString("C0F000").toColor(),
          index: 1,
          indexType: 1,
          numCards: 10,
          title: "Power & Precision",
        ),
        CardSet(
          id: "wild_water",
          color: TinyColor.fromString("00B8D8").toColor(),
          index: 2,
          indexType: 1,
          numCards: 10,
          title: "Wild Water",
        ),
        CardSet(
          id: "extreme_heights",
          color: TinyColor.fromString("D80078").toColor(),
          index: 3,
          indexType: 1,
          numCards: 10,
          title: "Extreme Heights",
        ),
      ],
    );
  }

  @override
  void add(cardCollection) async {
    throw UnimplementedError();
  }

  @override
  Future<CardCollection?> get(String id, CardCollectionContext? context) async {
    return cardCollections
        .where((collection) => collection.id == id)
        .firstOrNull;
  }

  @override
  Future<List<CardCollection>> getAll(CardCollectionContext? context) async {
    return cardCollections;
  }

  @override
  void remove(cardCollection) async {
    throw UnimplementedError();
  }

  @override
  void update(cardCollection) async {
    throw UnimplementedError();
  }
}
