import 'package:bear_necessities/bear_necessities.dart';
import 'package:get/get.dart';

class MockBearRewardRepository<T, C>
    implements BearRewardRepository<BearReward, BearRewardContext> {
  static List<BearReward> get chapters {
    return <BearReward>[
      BearReward(
        id: "bearilliant_beasts",
        index: 0,
        name: "Professor Ben Garrod",
        parts: <BearRewardPart>[
          const BearRewardPart(
            id: "professor_ben_garrod_gigantopithecus",
          ),
          const BearRewardPart(
            id: "professor_ben_garrod_megalodon",
          ),
          const BearRewardPart(
            id: "professor_ben_garrod_patagotitan",
          ),
          const BearRewardPart(
            id: "professor_ben_garrod_quetzacoatlus",
          ),
        ],
      ),
    ];
  }

  @override
  void add(reward) async {
    throw UnimplementedError();
  }

  @override
  Future<BearReward?> get(String id, BearRewardContext? context) async {
    return chapters.where((collection) => collection.id == id).firstOrNull;
  }

  @override
  Future<List<BearReward>> getAll(BearRewardContext? context) async {
    return chapters;
  }

  @override
  void remove(reward) async {
    throw UnimplementedError();
  }

  @override
  void update(reward) async {
    throw UnimplementedError();
  }
}
