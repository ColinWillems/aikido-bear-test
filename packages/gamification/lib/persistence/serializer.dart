class Serializer<T> {
  const Serializer({
    required this.deserialize,
    required this.serialize,
  });

  final T Function(Object? json) deserialize;

  final Object? Function(T object) serialize;
}
