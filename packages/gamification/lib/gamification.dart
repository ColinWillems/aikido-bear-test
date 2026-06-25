// ignore_for_file: unnecessary_getters_setters

library;

import 'dart:async';


import 'achievements/achievement.dart';
import 'persistence/persistence_manager.dart';
import 'persistence/shared_preferences_persistence_manager.dart';
export 'achievements/achievements.dart';
export 'persistence/persistence.dart';
export 'rewards/rewards.dart';

class Gamification {
  static Gamification? _instance;

  Gamification._internal(
      {this.enablePersistence = false, PersistenceManager? persistenceManager})
      : persistenceManager =
            persistenceManager ?? SharedPreferencesPersistenceManager() {
    _instance = this;
    persistenceManager = SharedPreferencesPersistenceManager();
  }

  factory Gamification(
          {bool enablePersistence = false,
          PersistenceManager? persistenceManager}) =>
      _instance ??
      Gamification._internal(
          enablePersistence: enablePersistence,
          persistenceManager: persistenceManager);

  bool enablePersistence = false;

  PersistenceManager persistenceManager;

  String _profile = "";
  String get profile => _profile;
  set profile(String value) {
    if (_profile != value) {
      _reset();
      _profile = value;
      for (var controller in activeProfileControllers) {
        controller.add(_profile);
      }
    }
  }

  List<StreamController<String>> activeProfileControllers =
      <StreamController<String>>[];

  Stream<String> get activeProfile {
    late StreamController<String> controller;

    void onListen() {
      activeProfileControllers.add(controller);
      Future.delayed(
          const Duration(milliseconds: 0), () => controller.add(_profile));
    }

    void onStop() {
      activeProfileControllers.remove(controller);
    }

    controller = StreamController<String>(
      onListen: onListen,
      onPause: onStop,
      onResume: onListen,
      onCancel: onStop,
    );

    return controller.stream;
  }

  final Map<dynamic, bool> _typesRestoring = {};

  bool isRestoring(dynamic type) {
    return _typesRestoring[type] ?? false;
  }

  void setRestoring(dynamic type, bool restoring) {
    _typesRestoring[type] = restoring;
  }

  final Map<dynamic, bool> _typesAddingMultiple = {};

  bool isAddingMultipleAchievements(dynamic type) {
    return _typesAddingMultiple[type] ?? false;
  }

  void setAddingMultipleAchievements(dynamic type, bool isMultiple) {
    _typesAddingMultiple[type] = isMultiple;
  }

  Future<void> save<T, R>() async {
    await persistenceManager.save<T, Achievement<T, R>>(
        _profile, getAchievements<T, R>());
  }

  Future<void> restore<T, R>() async {
    setRestoring(T, true);
    List<Achievement<T, R>> restoredAchievements =
        await persistenceManager.restore<T, Achievement<T, R>>(_profile);
    await addAchievements<T, R>(restoredAchievements);
    setRestoring(T, false);
  }

  Future<void> clearAll(String profile) async {
    await persistenceManager.clearAll(profile);
  }

  void _reset() {
    typesToAchievements.clear();
    List<dynamic> types = typesToRewards.keys.toList();
    typesToRewards.clear();
    for (var type in types) {
      _updateRewardsTotal(type);
    }
  }

  final Map<dynamic, List<dynamic>> typesToAchievements = {};

  List<Achievement<T, R>> _getAchievements<T, R>([bool modifiable = true]) {
    typesToAchievements[T] ??= <Achievement<T, R>>[];
    return ((modifiable)
            ? typesToAchievements[T]
            : typesToAchievements[T]!.toList(growable: false))
        as List<Achievement<T, R>>;
  }

  List<Achievement<T, R>> getAchievements<T, R>() {
    return _getAchievements<T, R>(false);
  }

  Future<void> addAchievement<T, R>(Achievement<T, R> achievement) async {
    final List<Achievement<T, R>> achievements = _getAchievements<T, R>();
    achievements.add(achievement);
    addReward(achievement.rewardType, achievement.rewardAmount);
    if (enablePersistence &&
        !isRestoring(T) &&
        !isAddingMultipleAchievements(T)) {
      await save<T, R>();
    }
  }

  Future<void> addAchievements<T, R>(
      List<Achievement<T, R>> achievements) async {
    setAddingMultipleAchievements(T, true);
    for (var achievement in achievements) {
      await addAchievement<T, R>(achievement);
    }
    setAddingMultipleAchievements(T, false);
    if (enablePersistence && !isRestoring(T)) {
      await save<T, R>();
    }
  }

  bool hasAchievement<T, R>(String id, dynamic type) {
    final List<Achievement<T, R>> achievements = _getAchievements<T, R>();
    return achievements
        .where(
            (achievement) => achievement.id == id && achievement.type == type)
        .isNotEmpty;
  }

  final Map<dynamic, num> typesToRewards = {};

  Map<Object, List<StreamController<num>>> controllers = {};

  void _updateRewardsTotal(dynamic type) {
    final controllersForType = controllers[type];
    if (controllersForType != null && controllersForType.isNotEmpty) {
      final newTotal = _getRewardsTotal(type);
      for (var controller in controllersForType) {
        controller.add(newTotal);
      }
    }
  }

  num _getRewardsTotal(dynamic type) {
    if (!typesToRewards.containsKey(type)) {
      typesToRewards[type] = 0;
    }

    final total = typesToRewards[type]!;
    return total;
  }

  Stream<num> getRewardsTotal(dynamic type) {
    late StreamController<num> controller;
    void onListen() {
      controllers[type] ??= <StreamController<num>>[];
      controllers[type]!.add(controller);
      Future.delayed(const Duration(milliseconds: 1),
          () => controller.add(_getRewardsTotal(type)));
    }

    void onStop() {
      if (controllers[type] != null) {
        controllers[type]!.remove(controller);
      }
    }

    controller = StreamController<num>(
      onListen: onListen,
      onPause: onStop,
      onResume: onListen,
      onCancel: onStop,
    );

    return controller.stream;
  }

  void addReward(dynamic type, num amount) {
    if (!typesToRewards.containsKey(type)) {
      typesToRewards[type] = 0;
    }
    typesToRewards[type] = typesToRewards[type]! + amount;
    _updateRewardsTotal(type);
  }

  void addRewards(Map<dynamic, num> rewards) {
    rewards.forEach(addReward);
  }
}
