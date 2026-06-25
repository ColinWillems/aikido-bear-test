import 'serializer.dart';

abstract class PersistenceManager {
  Future<void> save<T, U>(String profile, List<U> items) async {
    throw UnimplementedError(
        "You must call save on a concrete subclass of PersistenceManager");
  }

  Future<List<U>> restore<T, U>(String profile) async {
    throw UnimplementedError(
        "You must call restore on a concrete subclass of PersistenceManager");
  }

  Future<bool> clear<T, U>(String profile) async {
    throw UnimplementedError(
        "You must call clear on a concrete subclass of PersistenceManager");
  }

  Future<bool> clearAll(String profile) async {
    throw UnimplementedError(
        "You must call clear on a concrete subclass of PersistenceManager");
  }

  Map<String, Serializer> serializers = {};
}
