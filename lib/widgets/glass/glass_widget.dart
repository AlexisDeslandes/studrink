import 'dart:ui';

import 'package:flutter/material.dart';

class GlassWidget extends StatelessWidget {
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double opacity;
  final double radius;
  final Widget child;
  final double blur;

  const GlassWidget(
      {Key? key,
      required this.child,
      this.width,
      this.padding,
      this.opacity = 0.15,
      this.radius = 25.0,
      this.blur = 12.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: blur, sigmaX: blur),
        child: Container(
            padding: padding,
            width: width,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(opacity),
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(radius)),
            child: child),
      ),
    );
  }
}
