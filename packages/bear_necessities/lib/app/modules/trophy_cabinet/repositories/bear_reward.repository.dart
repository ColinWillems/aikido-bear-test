import 'package:bear_necessities/bear_necessities.dart';

class BearRewardRepository<BearReward, BearRewardContext>
    implements Repository<BearReward, BearRewardContext> {
  @override
  void add(BearReward reward) async {
    throw UnimplementedError(
        "You must call add on a concrete subclass of BearRewardRepository");
  }

  @override
  Future<BearReward?> get(String id, BearRewardContext? context) async {
    throw UnimplementedError(
        "You must call get on a concrete subclass of BearRewardRepository");
  }

  @override
  Future<List<BearReward>> getAll(BearRewardContext? context) async {
    throw UnimplementedError(
        "You must call get on a concrete subclass of BearRewardRepository");
  }

  @override
  void remove(BearReward reward) async {
    throw UnimplementedError(
        "You must call remove on a concrete subclass of BearRewardRepository");
  }

  @override
  void update(BearReward reward) async {
    throw UnimplementedError(
        "You must call update on a concrete subclass of BearRewardRepository");
  }
}

class BearRewardContext {
  const BearRewardContext(this.updatedDateTime);
  final DateTime updatedDateTime;
}
