import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class MockBearRewardPartRepository<T, C>
    implements BearRewardPartRepository<BearRewardPart, BearRewardPartContext> {
  static List<BearReward> get rewards {
    return <BearReward>[
      BearReward(
        id: "bearilliant_beasts",
        index: 0,
        parts: <BearRewardPart>[
          const BearRewardPart(
            id: "professor_ben_garrod_gigantopithecus",
            index: 0,
            name: "Gigantopithecus",
            externalUrl: "https://youtube.com/shorts/0aWp5BjBxr8",
          ),
          const BearRewardPart(
            id: "professor_ben_garrod_megalodon",
            index: 1,
            name: "Megalodon",
            externalUrl: "https://www.youtube.com/shorts/5IpTcXc_LW8",
          ),
          const BearRewardPart(
            id: "professor_ben_garrod_patagotitan",
            index: 2,
            name: "Patagotitan",
            externalUrl: "https://youtube.com/shorts/GEyXdZdZnWU",
          ),
          const BearRewardPart(
            id: "professor_ben_garrod_quetzacoatlus",
            index: 3,
            name: "Quetzalcoatlus",
            externalUrl: "https://youtube.com/shorts/7N7iviH9qIg",
          ),
        ],
      ),
    ];
  }

  BearReward? _getBearReward(String categoryId) {
    return rewards.where((category) => category.id == categoryId).firstOrNull;
  }

  @override
  void add(chapterPart) async {
    throw UnimplementedError();
  }

  @override
  Future<BearRewardPart?> get(String id, BearRewardPartContext? context) async {
    if (context == null) {
      throw const FormatException(
          "A BearRewardPartContext is required to get a BearRewardPart");
    }

    BearReward? chapter = _getBearReward(context.categoryId);

    if (chapter != null) {
      return chapter.parts
          .where((chapterPart) => chapterPart.id == id)
          .firstOrNull;
    }

    return null;
  }

  @override
  Future<List<BearRewardPart>> getAll(BearRewardPartContext? context) async {
    if (context == null) {
      throw const FormatException(
          "A BearRewardPartContext is required to get a BearRewardPart");
    }

    List<BearRewardPart> activities = <BearRewardPart>[];
    BearReward? chapter = _getBearReward(context.categoryId);

    if (chapter != null) {
      activities = chapter.parts.toList();
    }

    return activities;
  }

  @override
  void remove(chapterPart) async {
    throw UnimplementedError();
  }

  @override
  void update(chapterPart) async {
    throw UnimplementedError();
  }
}
