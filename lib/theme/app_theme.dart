import 'package:flutter/material.dart';

class AppTheme {
  static const AppTheme _instance = AppTheme._();

  factory AppTheme() => _instance;

  const AppTheme._();

  ThemeData get lightTheme {
    final lightTheme = ThemeData.light();
    final headline2 = TextStyle(
        color: Colors.black,
        fontFamily: "Helvetica",
        fontWeight: FontWeight.bold,
        fontSize: 30);
    return lightTheme.copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: lightTheme.scaffoldBackgroundColor,
        ),
        primaryColor: Color(0xffEFCF88),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                textStyle: headline2.copyWith(fontSize: 15))),
        buttonTheme: lightTheme.buttonTheme.copyWith(
          height: 68,
          minWidth: 166,
          buttonColor: Colors.white,
        ),
        textTheme: lightTheme.textTheme.copyWith(
            headline2: headline2,
            headline1: headline2.copyWith(fontSize: 50),
            bodyText1:
                headline2.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
            bodyText2:
                headline2.copyWith(fontSize: 22, fontWeight: FontWeight.w500),
            button: headline2));
  }
}
