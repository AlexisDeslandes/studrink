import 'package:flutter/material.dart';
import 'package:ptit_godet/painters/circle_blur_painter.dart';

class AppBackgroundPaint extends StatelessWidget {
  const AppBackgroundPaint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomPaint(
        size: MediaQuery.of(context).size,
        foregroundPainter: AppBackgroundPainter(
            primaryColor: theme.primaryColor,
            accentColor: theme.accentColor,
            backgroundColor: theme.scaffoldBackgroundColor,
            topPadding: MediaQuery.of(context).padding.top));
  }
}
