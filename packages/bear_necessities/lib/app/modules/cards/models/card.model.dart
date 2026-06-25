import 'package:bear_necessities/bear_necessities.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card.model.freezed.dart';

part 'card.model.g.dart';

@freezed
sealed class Card with _$Card {
  static const lockedId = "locked";
  const Card._();
  const factory Card({
    @Default(Card.lockedId) String id,
    @Default(99999) int index,
    @Default("Locked") String title,
    @Default(false) bool hasFront,
    @JsonKey(ignore: true) CardSet? set,
  }) = _Card;

  @override
  String get id;
  @override
  int get index;
  @override
  String get title;
  @override
  bool get hasFront;
  @override
  CardSet? get set;

  String get lockedImagePath {
    final collId = set?.collection?.id;
    final setId = set?.id;
    if (set == null || id.isEmpty || id == Card.lockedId || collId == null || setId == null) {
      return "";
    }
    return "images/cards/$collId/$setId/${id}_locked.png";
  }

  String get frontImagePath {
    final collId = set?.collection?.id;
    final setId = set?.id;
    if (set == null || id.isEmpty || id == Card.lockedId || !hasFront || collId == null || setId == null) {
      return "";
    }
    return "images/cards/$collId/$setId/${id}_front.png";
  }

  String get reverseImagePath {
    final collId = set?.collection?.id;
    final setId = set?.id;
    if (set == null || id.isEmpty || id == Card.lockedId || !hasFront || collId == null || setId == null) {
      return "";
    }
    return "images/cards/$collId/$setId/${id}_reverse.png";
  }

  String get showdownImagePath {
    final collId = set?.collection?.id;
    final setId = set?.id;
    if (set == null || id.isEmpty || id == Card.lockedId || !hasFront || collId == null || setId == null) {
      return "";
    }
    return frontImagePath.replaceFirst(RegExp(r'_front\.png'), "_showdown.png");
  }

  String get unlockImagePath {
    final collId = set?.collection?.id;
    final setId = set?.id;
    if (set == null || id.isEmpty || id == Card.lockedId || !hasFront || collId == null || setId == null) {
      return "";
    }
    return frontImagePath.replaceFirst(RegExp(r'_front\.png'), "_unlock.png");
  }

  bool get unlocked {
    return id.isNotEmpty && id != Card.lockedId && hasFront;
  }

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);
}
