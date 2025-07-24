import 'package:flutter/material.dart';

class AppTheme {
  static const AppTheme _instance = AppTheme._();

  factory AppTheme() => _instance;

  const AppTheme._();

  ThemeData get lightTheme {
    final lightTheme = ThemeData.light();
    final titleMedium = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30);
    return lightTheme.copyWith(
        scaffoldBackgroundColor: Color(0xff9b9db4),
        snackBarTheme: SnackBarThemeData(),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: lightTheme.scaffoldBackgroundColor,
        ),
        colorScheme: ColorScheme.light(
          primary: const Color(0xffca7375),
          secondary: const Color(0xFFE6BD66),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                textStyle: titleMedium.copyWith(fontSize: 15))),
        buttonTheme: lightTheme.buttonTheme.copyWith(
          height: 68,
          minWidth: 166,
          buttonColor: Colors.white,
        ),
        canvasColor: Colors.transparent,
        textTheme: lightTheme.textTheme.copyWith(
          titleSmall: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
          titleLarge: titleMedium.copyWith(fontSize: 40),
          titleMedium: titleMedium,
          bodyMedium:
              titleMedium.copyWith(fontSize: 16, fontWeight: FontWeight.w300),
        ));
  }
}
