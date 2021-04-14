import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/painters/circle_blur_painter.dart';
import 'package:ptit_godet/theme/app_theme.dart';
import 'package:ptit_godet/widgets/paints/app_background_paint.dart';

void main() {
  runApp(MaterialApp(home: MyApp(), theme: AppTheme().lightTheme));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 400,
          height: 200,
          width: 200,
          child: const AppBackgroundPaint(child: const SizedBox()),
        ),
        const Positioned(
          top: 0,
          left: 0,
          height: 200,
          width: 200,
          child: CustomPaint(
            painter: AppBackgroundPainter(
                topPadding: 10,
                primaryColor: Colors.green,
                accentColor: Colors.red,
                backgroundColor: Colors.yellow),
          ),
        )
      ],
    );
  }
}
