import 'package:flutter/material.dart';
import 'package:studrink/painters/circle_blur_painter.dart';

///
/// [Widget] used to wrap app pages to
/// give a nice background.
///
class AppBackgroundPaint extends StatelessWidget {
  const AppBackgroundPaint({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return CustomPaint(
        child: child,
        size: MediaQuery.of(context).size,
        painter: AppBackgroundPainter(
            primaryColor: colorScheme.primary,
            accentColor: colorScheme.secondary,
            backgroundColor: theme.scaffoldBackgroundColor,
            topPadding: MediaQuery.of(context).padding.top));
  }
}
