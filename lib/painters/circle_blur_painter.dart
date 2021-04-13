import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppBackgroundPainter extends CustomPainter {
  const AppBackgroundPainter(
      {required this.topPadding,
      required this.primaryColor,
      required this.accentColor,
      required this.backgroundColor});

  final double topPadding;
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    const blurSigma = 50.0;
    final width = size.width,
        topCircleRadius = width * 2 / 3,
        bottomCircleSize = width * 3 / 5;
    var center, radius;

    final background = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.largest, background);

    final topCircle = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    center = Offset(0, topPadding);
    radius = topCircleRadius;
    canvas.drawCircle(center, radius, topCircle);

    center = Offset(width, topPadding);
    radius = topCircleRadius;
    canvas.drawCircle(center, radius, topCircle);

    final bottomCircle = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    center = Offset(0, size.height);
    radius = bottomCircleSize;
    canvas.drawCircle(center, radius, bottomCircle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
