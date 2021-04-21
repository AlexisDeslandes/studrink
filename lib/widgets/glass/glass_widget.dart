import 'dart:ui';

import 'package:flutter/material.dart';

class GlassWidget extends StatelessWidget {
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double opacity;
  final double radius;
  final Widget child;
  final double blur;
  final bool border;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const GlassWidget(
      {Key? key,
      required this.child,
      this.width,
      this.padding,
      this.opacity = 0.15,
      this.radius = 25.0,
      this.blur = 12.0,
      this.border = true,
      this.borderRadius,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: blur, sigmaX: blur),
        child: Container(
            padding: padding,
            width: width,
            decoration: BoxDecoration(
                color: backgroundColor?.withOpacity(opacity) ??
                    Colors.white.withOpacity(opacity),
                border:
                    border ? Border.all(color: Colors.white, width: 1) : null,
                borderRadius: borderRadius ?? BorderRadius.circular(radius)),
            child: child),
      ),
    );
  }
}
