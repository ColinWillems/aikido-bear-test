enum BearRewardPartKind {
  video("v", "video");

  const BearRewardPartKind(this.shortName, this.longName);
  final String shortName;
  final String longName;

  static BearRewardPartKind byShortName(String shortName) {
    for (var value in BearRewardPartKind.values) {
      if (value.shortName == shortName) return value;
    }

    throw ArgumentError.value(
        shortName, "shortName", "No BearRewardPartKind value with that name");
  }

  @override
  String toString() => 'BearRewardPartKind($shortName, $longName)';
}
