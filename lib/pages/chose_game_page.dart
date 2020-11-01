import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/board_game/board_game_bloc.dart';
import 'package:ptit_godet/widgets/back_element_screen.dart';
import 'package:ptit_godet/widgets/base_building.dart';
import 'package:ptit_godet/widgets/board_game_tile.dart';
import 'package:ptit_godet/widgets/simple_title_screen.dart';

class ChoseGamePage extends CupertinoPage {
  const ChoseGamePage()
      : super(
            child: const ChoseGameScreen(),
            key: const ValueKey<String>("/chose_game"));
}

class ChoseGameScreen extends BackElementScreen with BaseBuilding, SimpleTitleScreen {
  const ChoseGameScreen();

  @override
  String backButtonText() => "Accueil";

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<BoardGameBloc, BoardGameState>(
        builder: (context, state) {
      final boardGameList = state.boardGameList;
      if (boardGameList.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: ListView.builder(
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: BoardGameTile(boardGame: boardGameList[index]),
            ),
            itemCount: boardGameList.length,
          ),
        );
      } else {
        return Center(
          child: Text("Aucun plateau de jeu n'a été créé.",
              style: Theme.of(context).textTheme.bodyText2),
        );
      }
    });
  }

  @override
  String titleContent() => "Jouer";
}
