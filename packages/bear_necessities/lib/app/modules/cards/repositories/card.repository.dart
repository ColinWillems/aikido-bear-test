import 'package:bear_necessities/bear_necessities.dart';

class CardRepository<Card, CardContext>
    implements Repository<Card, CardContext> {
  @override
  void add(Card card) async {
    throw UnimplementedError(
        "You must call add on a concrete subclass of CardRepository");
  }

  @override
  Future<Card?> get(String id, CardContext? context) async {
    throw UnimplementedError(
        "You must call get on a concrete subclass of CardRepository");
  }

  @override
  Future<List<Card>> getAll(CardContext? context) async {
    throw UnimplementedError(
        "You must call get on a concrete subclass of CardRepository");
  }

  @override
  void remove(Card card) async {
    throw UnimplementedError(
        "You must call remove on a concrete subclass of CardRepository");
  }

  @override
  void update(Card card) async {
    throw UnimplementedError(
        "You must call update on a concrete subclass of CardRepository");
  }
}

class CardContext {
  const CardContext(this.setId, this.collectionId);
  final String? setId;
  final String collectionId;
}
