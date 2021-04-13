import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/pages/app_background.dart';
import 'package:ptit_godet/theme/app_theme.dart';

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
    return AppBackground(
      child: const SizedBox.shrink(),
    );
  }
}
