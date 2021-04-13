import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return const AppBackgroundPaint(child: const SizedBox());
  }
}
