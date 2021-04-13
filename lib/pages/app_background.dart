import 'package:flutter/material.dart';
import 'package:ptit_godet/widgets/paints/app_background_paint.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppBackgroundPaint();
  }
}
