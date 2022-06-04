import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color get contrastColor =>
      computeLuminance() > 0.5 ? Colors.black : Colors.white;
}
