import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ptit_godet/blocs/provider/app_provider.dart';
import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/models/cell.dart';
import 'package:ptit_godet/models/condition_key.dart';
import 'package:ptit_godet/models/prison_condition.dart';
import 'package:ptit_godet/models/throw_dice_effect.dart';
import 'package:ptit_godet/storage/local_storage.dart';
import 'package:ptit_godet/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/moving.dart';
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
          Cell(
              name: "Rentrée",
              imgPath: "",
              sideEffectList: ["C'est la rentrée !"]),
          Cell(
              cellType: CellType.selfMoving,
              moving: Moving(count: 2, movingType: MovingType.forward),
              name: "Polypoint",
              imgPath: "",
              givenConditionKey: ConditionKey(name: "Polypoint")),
          Cell(
              name: "BressomLand",
              imgPath: "",
              sideEffectList: ["Ca part en cul sec."]),
          Cell(name: "Clausse", imgPath: "", sideEffectList: ["Tu bois."]),
          Cell(
              name: "WEC1",
              imgPath: "",
              sideEffectList: ["Tu bois"],
              sideEffectListAfterTurnLost: ["Tu bois"],
              cellType: CellType.turnLose),
          Cell(
              name: "Parking",
              imgPath: "",
              sideEffectList: ["Invente ta propre règle."]),
          Cell(
              name: "Partiel",
              imgPath: "",
              cellType: CellType.prison,
              prisonCondition: PrisonCondition([3, 4]),
              sideEffectList: ["Plus le droit de boire."]),
          Cell(
              name: "Balais-couille",
              imgPath: "",
              cellType: CellType.selfThrowDice,
              throwDiceEffect: ThrowDiceEffect(sideEffect: "Bois sa valeur.")),
          Cell(
              name: "Polypoint",
              imgPath: "",
              cellType: CellType.selfChallenge,
              challenge: "Bois un cul sec.",
              givenConditionKey: ConditionKey(name: "Polypoint")),
          Cell(
            name: "Sodomie",
            imgPath: "",
            cellType: CellType.selfMovingUndetermined,
            movingUndeterminedCount: 1
          ),
          Cell(
              name: "Depardieu",
              imgPath: "",
              sideEffectList: ["Tout le monde boit."]),
          Cell(
              name: "4a",
              imgPath: "",
              cellType: CellType.conditionKey,
              givenConditionKey: ConditionKey(name: "Polypoint"),
              requiredConditionKey: ConditionKey(name: "Polypoint")),
          Cell(
              name: "Otrak",
              imgPath: "",
              sideEffectList: ["Bois un cimetière."]),
          Cell(
              name: "Intégration BDSM",
              imgPath: "",
              givenConditionKey: ConditionKey(name: "BDSM")),
          Cell(name: "Shi Fu Cuite", imgPath: ""),
          Cell(name: "Parking", imgPath: ""),
          Cell(
              name: "WEC2",
              imgPath: "",
              sideEffectList: ["Bois un cul sec.", "Embrasse le plus bourré."]),
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
