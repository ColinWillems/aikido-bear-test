import 'package:bear_necessities/bear_necessities.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bear_reward_part.model.freezed.dart';

part 'bear_reward_part.model.g.dart';

@pragma("vm:entry-point")
@freezed
sealed class BearRewardPart with _$BearRewardPart {
  const BearRewardPart._();
  @JsonSerializable(explicitToJson: true)
  const factory BearRewardPart({
    @Default("") String id,
    @Default("") String name,
    @Default(0) int index,
    @Default("") String intro,
    @Default("") String externalUrl,
    dynamic data,
    @JsonKey(
        fromJson: BearRewardPart.kindFromJson,
        toJson: BearRewardPart.kindToJson)
    @Default(BearRewardPartKind.video)
    BearRewardPartKind kind,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool completed,
    @JsonKey(includeFromJson: false, includeToJson: false) BearReward? reward,
  }) = _BearRewardPart;

  @override
  String get id;
  @override
  String get name;
  @override
  int get index;
  @override
  String get intro;
  @override
  bool get completed;
  @override
  BearRewardPartKind get kind;
  @override
  BearReward? get reward;
  @override
  String get externalUrl;
  @override
  dynamic get data;

  bool get loaded {
    return name.isNotEmpty;
  }

  String get imagePath {
    return (id.isEmpty)
        ? ""
        : "${BearApp.imagesPath}/${TrophyCabinet.rootPath}/${reward?.id}/$id${BearApp.imageExtension}";
  }

  String get secondaryImagePath {
    return (id.isEmpty)
        ? ""
        : "${BearApp.imagesPath}/${TrophyCabinet.rootPath}/${reward?.id}/$id/secondary${BearApp.imageExtension}";
  }

  factory BearRewardPart.fromJson(Map<String, dynamic> json) =>
      _$BearRewardPartFromJson(json);

  static Object? rewardPartToJson(BearRewardPart rewardPart) {
    return rewardPart.toJson();
  }

  static BearRewardPart rewardPartFromJson(Object? json) {
    return BearRewardPart.fromJson(json as Map<String, Object?>);
  }

  static BearRewardPartKind kindFromJson(String json) {
    return BearRewardPartKind.byShortName(json);
  }

  static String kindToJson(BearRewardPartKind kind) {
    return kind.shortName;
  }
}
