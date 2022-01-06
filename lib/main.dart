import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studrink/blocs/provider/app_provider.dart';
import 'package:studrink/storage/local_storage.dart';
import 'package:studrink/theme/app_theme.dart';
import 'package:studrink/widgets/paints/app_background_paint.dart';
import 'package:studrink/widgets/sd_game_slider.dart';

import 'blocs/current_game/current_game_bloc.dart';
import 'blocs/dice/dice_bloc.dart';
import 'blocs/focused_cell_bloc/focused_cell_bloc.dart';
import 'blocs/nav/nav_bloc.dart';
import 'models/board_game.dart';
import 'models/cell.dart';
import 'models/condition_key.dart';
import 'models/player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  LocalStorage(sharedPreferences: await SharedPreferences.getInstance());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Studrink",
        theme: AppTheme().lightTheme,
        home: AppProvider(
            child: AppBackgroundPaint(
                child: Scaffold(
                    //body: const MainNavigator(),
                    body: Center(
                      child: Builder(
                        builder: (context) => BlocProvider(
                            create: (context) => CurrentGameBloc(
                                navBloc: NavBloc(),
                                diceBloc: DiceBloc(),
                                focusedCellBloc: FocusedCellBloc())
                              ..emit(CurrentGameState(
                                  playerList: [
                                    Player(
                                        conditionKeyList: [
                                          ConditionKey(name: "Polypoint")
                                        ],
                                        state: PlayerState.ready,
                                        name: "Alexis",
                                        color: Colors.red,
                                        idCurrentCell: 2,
                                        id: 0),
                                    Player(
                                        conditionKeyList: [
                                          ConditionKey(name: "Polypoint")
                                        ],
                                        state: PlayerState.ready,
                                        name: "Thomas",
                                        color: Colors.orange,
                                        idCurrentCell: 1,
                                        id: 1),
                                    Player(
                                        conditionKeyList: [
                                          ConditionKey(name: "Polypoint")
                                        ],
                                        state: PlayerState.ready,
                                        name: "Eva",
                                        color: Colors.green,
                                        idCurrentCell: 0,
                                        id: 2),
                                    Player(
                                        conditionKeyList: [
                                          ConditionKey(name: "Polypoint")
                                        ],
                                        state: PlayerState.ready,
                                        name: "Renaud",
                                        color: Colors.green,
                                        idCurrentCell: 3,
                                        id: 3)
                                  ],
                                  boardGame: BoardGame(
                                      name: "Jeux de l'oie",
                                      cells: List.filled(
                                          35,
                                          Cell(
                                              name: "Rentrée",
                                              imgPath: "",
                                              sideEffectList: [
                                                "C'est la rentrée !"
                                              ])),
                                      imgUrl: '',
                                      date: DateTime.now()),
                                  indexCurrentPlayer: 0,
                                  indexNextPlayer: 0)),
                            child: SDGameSlider()),
                      ),
                    ),
                    backgroundColor: Colors.transparent))));
  }
}
