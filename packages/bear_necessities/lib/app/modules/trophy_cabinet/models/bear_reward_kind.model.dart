enum BearRewardKind {
  cardCollection("cc", "cardCollection");

  const BearRewardKind(this.shortName, this.longName);
  final String shortName;
  final String longName;

  static BearRewardKind byShortName(String shortName) {
    for (var value in BearRewardKind.values) {
      if (value.shortName == shortName) return value;
    }

    throw ArgumentError.value(
        shortName, "shortName", "No BearRewardKind value with that name");
  }

  @override
  String toString() => 'BearRewardKind($shortName, $longName)';
}
