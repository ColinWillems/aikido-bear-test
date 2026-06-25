import 'dart:convert';
import 'persistence_manager.dart';
import 'serializer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesPersistenceManager implements PersistenceManager {
  SharedPreferencesPersistenceManager();

  static const String key = "persisted_";

  @override
  Map<String, Serializer> serializers = {};

  @override
  Future<List<U>> restore<T, U>(String profile) async {
    final prefs = await SharedPreferences.getInstance();
    List<U> output = <U>[];
    final String? stored = prefs.getString("$key$profile|$T");
    if (stored != null) {
      final tempList = jsonDecode(
        stored,
      ) as List<dynamic>;

      if (serializers[U.toString()] != null) {
        tempList.removeWhere((element) => element is String && element.isEmpty);
        output = tempList
            .map<U>(
                (element) => serializers[U.toString()]!.deserialize(element))
            .toList();
      }
    }
    return output;
  }

  @override
  Future<void> save<T, U>(String profile, List<U> items) async {
    final prefs = await SharedPreferences.getInstance();
    final String toStore = jsonEncode(items, toEncodable: (Object? value) {
      Object? output = "";
      String typeKey = U.toString();
      bool valueIsType = value is U;
      bool serializerExists = serializers[typeKey] != null;
      if (valueIsType && serializerExists) {
        try {
          output = serializers[typeKey]!.serialize(value);
        } catch (e) {}
      }
      return output;
    });
    await prefs.setString("$key$profile|$T", toStore);
  }

  @override
  Future<bool> clear<T, U>(String profile) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove("$key$profile|$T");
  }

  @override
  Future<bool> clearAll(String profile) async {
    bool result = true;
    final prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    for (var key in keys) {
      if (key.startsWith("$key$profile|")) {
        result = await prefs.remove(key);
      }
    }
    return result;
  }
}
