enum ProfileDecorationType {
  hat("hat"),
  accessory("acc");

  const ProfileDecorationType(this.shortName);
  final String shortName;

  static ProfileDecorationType? byShortName(String shortName) {
    return ProfileDecorationType.values
        .firstWhere((decoration) => decoration.shortName == shortName);
  }

  @override
  String toString() => 'ProfileDecorationType($shortName)';
}
