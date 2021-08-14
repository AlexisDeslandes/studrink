import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

extension MapExtension on Map {
  static Tuple2<K?, K?> getWinAndLost<K, T extends int>(
      Map<K, T> old, Map<K, T> current) {
    var win, lost;
    if (current.length != old.length)
      win ??= current.entries
          .firstWhereOrNull((element) => element.value == 1)
          ?.key;
    for (var oldEntry in old.entries) {
      final key = oldEntry.key;
      T? currValue = current[key];
      if (currValue == null)
        lost ??= key;
      else if (currValue < oldEntry.value)
        lost ??= key;
      else if (currValue > oldEntry.value) win ??= key;
    }
    return Tuple2(win, lost);
  }
}
