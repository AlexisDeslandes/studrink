import 'package:flutter/material.dart';

class AppTheme {
  static const AppTheme _instance = AppTheme._();

  factory AppTheme() => _instance;

  const AppTheme._();

  ThemeData get lightTheme {
    final lightTheme = ThemeData.light();
    final headline2 = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30);
    return lightTheme.copyWith(
        scaffoldBackgroundColor: Color(0xffE2D5D4),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: lightTheme.scaffoldBackgroundColor,
        ),
        primaryColor: const Color(0xffca7375),
        accentColor: const Color(0xFFE6BD66),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                textStyle: headline2.copyWith(fontSize: 15))),
        buttonTheme: lightTheme.buttonTheme.copyWith(
          height: 68,
          minWidth: 166,
          buttonColor: Colors.white,
        ),
        canvasColor: Colors.transparent,
        textTheme: lightTheme.textTheme.copyWith(
            subtitle1: TextStyle(
                color: Color(0xff663A3C),
                fontWeight: FontWeight.w500,
                fontSize: 16),
            headline1: headline2.copyWith(fontSize: 40),
            headline2: headline2,
            bodyText1:
                headline2.copyWith(fontSize: 16, fontWeight: FontWeight.w300),
            bodyText2:
                headline2.copyWith(fontSize: 22, fontWeight: FontWeight.w500),
            button: headline2));
  }
}
