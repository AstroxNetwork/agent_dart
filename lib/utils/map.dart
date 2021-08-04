Map makeBigIntToString(Map input) {
  var newX = {};
  for (var index in input.entries) {
    newX.putIfAbsent(
        index.key is BigInt ? index.key.toString() : index.key,
        () => index.value is BigInt
            ? index.value.toString()
            : index.value is Map
                ? makeBigIntToString(index.value)
                : index.value);
  }
  return newX;
}
