extension ToMap<T> on List<T> {
  Map<U, V> toMap<U, V>(
      U Function(T element) keyFunction, V Function(T element) valueFunction) {
    final outputMap = <U, V>{};
    // ignore: avoid_function_literals_in_foreach_calls, unnecessary_this
    this.forEach((T element) {
      final U key = keyFunction(element);
      if (key != null) {
        outputMap[key] = valueFunction(element);
      }
    });
    return outputMap;
  }
}
