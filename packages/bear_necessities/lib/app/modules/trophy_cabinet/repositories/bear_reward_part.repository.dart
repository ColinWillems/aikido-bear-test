import 'package:bear_necessities/bear_necessities.dart';

class BearRewardPartRepository<BearRewardPart, BearRewardPartContext>
    implements Repository<BearRewardPart, BearRewardPartContext> {
  @override
  void add(BearRewardPart reward) async {
    throw UnimplementedError(
        "You must call add on a concrete subclass of BearRewardPartRepository");
  }

  @override
  Future<BearRewardPart?> get(String id, BearRewardPartContext? context) async {
    throw UnimplementedError(
        "You must call get on a concrete subclass of BearRewardPartRepository");
  }

  @override
  Future<List<BearRewardPart>> getAll(BearRewardPartContext? context) async {
    throw UnimplementedError(
        "You must call get on a concrete subclass of BearRewardPartRepository");
  }

  @override
  void remove(BearRewardPart reward) async {
    throw UnimplementedError(
        "You must call remove on a concrete subclass of BearRewardPartRepository");
  }

  @override
  void update(BearRewardPart reward) async {
    throw UnimplementedError(
        "You must call update on a concrete subclass of BearRewardPartRepository");
  }
}

class BearRewardPartContext {
  const BearRewardPartContext(this.categoryId);
  final String categoryId;
}
