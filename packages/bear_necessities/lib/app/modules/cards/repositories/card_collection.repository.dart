import 'package:bear_necessities/bear_necessities.dart';

class CardCollectionRepository<CardCollection, CardCollectionContext>
    implements Repository<CardCollection, CardCollectionContext> {
  @override
  void add(CardCollection cardCollection) async {
    throw UnimplementedError(
        "You must call add on a concrete subclass of CardCollectionRepository");
  }

  @override
  Future<CardCollection?> get(String id, CardCollectionContext? context) async {
    throw UnimplementedError(
        "You must call get on a concrete subclass of CardCollectionRepository");
  }

  @override
  Future<List<CardCollection>> getAll(CardCollectionContext? context) async {
    throw UnimplementedError(
        "You must call get on a concrete subclass of CardCollectionRepository");
  }

  @override
  void remove(CardCollection item) async {
    throw UnimplementedError(
        "You must call remove on a concrete subclass of CardCollectionRepository");
  }

  @override
  void update(CardCollection item) async {
    throw UnimplementedError(
        "You must call update on a concrete subclass of CardCollectionRepository");
  }
}

class CardCollectionContext {
  const CardCollectionContext(this.updatedDateTime);
  final DateTime updatedDateTime;
}
