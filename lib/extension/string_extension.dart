import 'dart:math';

extension StringExtension on String {
  static String generateRandomString([int len = 10]) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }
}
