extension ListExtension<T> on List<T> {
  Map<T, int> countByItem() =>
      this.fold<Map<T, int>>({}, (previousValue, element) {
        if (previousValue.containsKey(element))
          return previousValue..[element] = previousValue[element]! + 1;
        return previousValue..[element] = 1;
      });
}
