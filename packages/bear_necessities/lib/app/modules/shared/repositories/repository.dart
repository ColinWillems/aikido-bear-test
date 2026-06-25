abstract class Repository<T, C> {
  void add(T item) async {
    throw UnimplementedError(
        "You must call add on a concrete subclass of Repository");
  }

  void update(T item) async {
    throw UnimplementedError(
        "You must call update on a concrete subclass of Repository");
  }

  void remove(T item) async {
    throw UnimplementedError(
        "You must call remove on a concrete subclass of Repository");
  }

  Future<T?> get(String id, C? context) async {
    throw UnimplementedError(
        "You must call get on a concrete subclass of Repository");
  }

  Future<List<T>> getAll(C? context) async {
    throw UnimplementedError(
        "You must call get on a concrete subclass of Repository");
  }
}
