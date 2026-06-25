import 'package:bear_necessities/bear_necessities.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart' hide DeepCollectionEquality;
import 'package:path/path.dart' as path;

part 'bear_reward.model.freezed.dart';

part 'bear_reward.model.g.dart';

@pragma("vm:entry-point")
@Freezed(makeCollectionsUnmodifiable: false)
sealed class BearReward with _$BearReward {
  const BearReward._();
  @JsonSerializable(explicitToJson: true)
  factory BearReward({
    String id = "",
    int index = 0,
    String name = "",
    BearRewardKind kind = BearRewardKind.cardCollection,
    String intro = "",
    String outro = "",
    List<BearRewardPart> parts = const <BearRewardPart>[],
  }) {
    final reward = _BearReward(
      id: id,
      index: index,
      name: name,
      kind: kind,
      intro: intro,
      outro: outro,
      parts: <BearRewardPart>[],
    );
    reward.replaceAllBearRewardParts(parts);

    return reward;
  }
  /* const factory BearReward({
    @Default(TrophyCabinet.defaultRewardId) String id,
    @Default(0) int index,
    @Default("") String name,
    @Default(BearRewardKind.cardCollection) BearRewardKind kind,
    @Default("") String intro,
    @Default("") String outro,
    @Default(<BearRewardPart>[]) List<BearRewardPart> parts,
  }) = _BearReward; */

  @override
  String get id;
  @override
  int get index;
  @override
  String get name;
  @override
  BearRewardKind get kind;
  @override
  String get intro;
  @override
  String get outro;
  @override
  List<BearRewardPart> get parts;

  String get imagePath {
    return path.join(
      BearApp.imagesPath,
      TrophyCabinet.rootPath,
      id + BearApp.imageExtension,
    );
  }

  bool get completed {
    for (var part in parts) {
      if (!part.completed) {
        return false; // return early if any reward part has not been completed yet
      }
    }
    return parts.isNotEmpty;
  }

  bool get locked {
    return parts.isEmpty;
  }

  BearRewardPart addBearRewardPart(BearRewardPart rewardPart) {
    final connectedBearRewardPart = _assignBearRewardPart(rewardPart);
    final int position = parts.indexWhere(
        (existingBearRewardPart) => existingBearRewardPart.id == rewardPart.id);
    if (position == -1) {
      parts.add(connectedBearRewardPart);
    } else {
      parts[position] = connectedBearRewardPart;
    }
    return connectedBearRewardPart;
  }

  List<BearRewardPart> addBearRewardParts(
      List<BearRewardPart> newBearRewardParts) {
    final connectedBearRewardParts =
        newBearRewardParts.map(_assignBearRewardPart);
    for (var rewardPart in connectedBearRewardParts) {
      addBearRewardPart(rewardPart);
    }
    return connectedBearRewardParts.toList();
  }

  BearRewardPart _assignBearRewardPart(BearRewardPart rewardPart) {
    return BearRewardPart(
      id: rewardPart.id,
      index: rewardPart.index,
      name: rewardPart.name,
      intro: rewardPart.intro,
      externalUrl: rewardPart.externalUrl,
      kind: rewardPart.kind,
      reward: this,
      completed: rewardPart.completed,
    );
  }

  List<BearRewardPart> replaceAllBearRewardParts(
      List<BearRewardPart> newBearRewardParts) {
    final connectedBearRewardParts =
        newBearRewardParts.map(_assignBearRewardPart);
    parts.assignAll(connectedBearRewardParts);
    return connectedBearRewardParts.toList();
  }

  BearRewardPart setBearRewardPartStatus(
      BearRewardPart rewardPart, bool completed) {
    final int position = parts.indexWhere(
        (existingBearRewardPart) => existingBearRewardPart.id == rewardPart.id);
    if (position > -1) {
      final BearRewardPart newBearRewardPart =
          parts[position].copyWith(completed: completed);
      parts[position] = newBearRewardPart;
      rewardPart = newBearRewardPart;
    }
    return rewardPart;
  }

  void resetAllBearRewardPartStatuses() {
    for (var i = 0; i < parts.length; ++i) {
      var rewardPart = parts[i].copyWith(completed: false);
      parts[i] = rewardPart;
    }
  }

  factory BearReward.fromJson(Map<String, dynamic> json) =>
      _$BearRewardFromJson(json);

  static Object? rewardToJson(BearReward reward) {
    return reward.toJson();
  }

  static BearReward rewardFromJson(Object? json) {
    return BearReward.fromJson(json as Map<String, Object?>);
  }
}
