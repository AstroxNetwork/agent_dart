List<T> flatternArray<T>(List<List<T>> list) {
  return list.expand<T>((element) => element).toList();
}
