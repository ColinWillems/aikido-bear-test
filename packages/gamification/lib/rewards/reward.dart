abstract class Reward<T> {
  const Reward({
    required this.type,
    required this.amount,
  }) : assert(type is T);

  final dynamic type;
  final num amount;

  Map<String, dynamic> toJson();
}
