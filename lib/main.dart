import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ptit_godet/blocs/provider/app_provider.dart';
import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/models/cell.dart';
import 'package:ptit_godet/storage/local_storage.dart';
import 'package:ptit_godet/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigators/main_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage =
      LocalStorage(sharedPreferences: await SharedPreferences.getInstance());
  await storage.clear();
  storage.write(
      LocalStorageKeywords.boardGameList,
      jsonEncode([
        BoardGame(name: "Jeu de l'oie", cells: [
          Cell(name: "Polypoint", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "Polypoint", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "Polypoint", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "BressomLand", imgPath: ""),
          Cell(name: "BressomLand", imgPath: "")
        ]).toJson()
      ]));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "P'tit Godet",
        theme: AppTheme().lightTheme,
        home: AppProvider(child: const MainNavigator()));
  }
}
