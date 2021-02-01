import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/board_game/board_game_bloc.dart';
import 'package:ptit_godet/widgets/back_element_screen.dart';
import 'package:ptit_godet/widgets/base_building.dart';
import 'package:ptit_godet/widgets/pre_game/board_game_tile.dart';
import 'package:ptit_godet/widgets/simple_title_screen.dart';

class CreateHomePage extends CupertinoPage {
  const CreateHomePage()
      : super(child: const CreateHomeScreen(), key: const ValueKey("/create"));
}

class CreateHomeScreen extends StatefulWidget {
  const CreateHomeScreen();

  @override
  State<StatefulWidget> createState() => CreateHomeScreenState();
}

class CreateHomeScreenState extends BackElementScreenState
    with BaseBuildingState, SimpleTitleScreen {
  @override
  String backButtonText() {
    return "Accueil";
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: BlocBuilder<BoardGameBloc, BoardGameState>(
            builder: (context, state) => ListView.builder(
              itemCount: state.boardGameList.length,
              itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: BoardGameTile(
                      boardGame: state.boardGameList[index],
                      onTap: () {
                        //todo
                      })),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: Theme.of(context).primaryColor),
            onPressed: () {
              //todo
            }));
  }

  @override
  String titleContent() {
    return "Parties";
  }
}
