import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///
/// [CustomPainter] used to draw app background.
/// It fills with a background, three blurred circle
/// and some "bubbles" above.
///
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
    const blurSigma = 50.0, tinyCircleRadius = 27.5;
    final width = size.width,
        topCircleRadius = width * 2 / 3,
        bottomCircleSize = width * 3 / 5;
    var center, radius;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.largest, backgroundPaint);

    final blurPrimaryPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    center = Offset(0, topPadding);
    radius = topCircleRadius;
    canvas.drawCircle(center, radius, blurPrimaryPaint);

    center = Offset(width, topPadding);
    radius = topCircleRadius;
    canvas.drawCircle(center, radius, blurPrimaryPaint);

    final blurAccentPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    center = Offset(0, size.height);
    radius = bottomCircleSize;
    canvas.drawCircle(center, radius, blurAccentPaint);

    final yellowGradient = LinearGradient(
            colors: [Colors.white, accentColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
        primaryGradient = LinearGradient(
            colors: [Colors.white, primaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter);
    center =
        Offset(width - 3 * tinyCircleRadius, topPadding + tinyCircleRadius * 2);
    final tinyYellowPaint = Paint()
      ..shader = yellowGradient.createShader(
          Rect.fromCircle(center: center, radius: tinyCircleRadius));
    canvas.drawCircle(center, tinyCircleRadius, tinyYellowPaint);

    final bigCircleRadius = width * 0.19;
    center = Offset(width - 20 - bigCircleRadius, size.height / 2);
    final bigYellowPaint = Paint()
      ..shader = yellowGradient.createShader(
          Rect.fromCircle(center: center, radius: bigCircleRadius));
    canvas.drawCircle(center, bigCircleRadius, bigYellowPaint);

    final midCircleRadius = bigCircleRadius - 12.5;
    center = Offset(width / 2, size.height * 0.237 + midCircleRadius);
    final topPrimaryPaint = Paint()
      ..shader = primaryGradient.createShader(
          Rect.fromCircle(center: center, radius: midCircleRadius));
    canvas.drawCircle(center, midCircleRadius, topPrimaryPaint);

    center = Offset(
        width * 0.16 + midCircleRadius, size.height * 0.586 + midCircleRadius);
    final bottomPrimaryPaint = Paint()
      ..shader = primaryGradient.createShader(
          Rect.fromCircle(center: center, radius: midCircleRadius));
    canvas.drawCircle(center, midCircleRadius, bottomPrimaryPaint);

    center = Offset(3 * tinyCircleRadius, size.height - 3 * tinyCircleRadius);
    final tinyPrimaryPaint = Paint()
      ..shader = primaryGradient.createShader(
          Rect.fromCircle(center: center, radius: tinyCircleRadius));
    canvas.drawCircle(center, tinyCircleRadius, tinyPrimaryPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
