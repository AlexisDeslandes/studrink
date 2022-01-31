import 'package:flutter/material.dart';

extension ColorExtension on Color {
  bool get shouldTextColorBeWhite {
    const half = 127.5;
    return red < half || green < half || blue < half;
  }
}
