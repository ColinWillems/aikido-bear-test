// ignore_for_file: public_member_api_docs, sort_constructors_first

abstract class Achievement<T, R> {
  const Achievement({
    required this.type,
    required this.id,
    required this.rewardType,
    required this.rewardAmount,
    required this.dateTime,
  }); // : assert(type is T);

  final dynamic type;
  final String id;
  final dynamic rewardType;
  final num rewardAmount;
  final DateTime dateTime;

  Map<String, dynamic> toJson();

}
