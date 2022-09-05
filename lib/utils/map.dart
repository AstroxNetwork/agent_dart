Map makeBigIntToString(Map input) {
  final newX = {};
  for (final index in input.entries) {
    newX.putIfAbsent(
      index.key is BigInt ? index.key.toString() : index.key,
      () => index.value is BigInt
          ? index.value.toString()
          : index.value is Map
              ? makeBigIntToString(index.value)
              : index.value,
    );
  }
  return newX;
}
