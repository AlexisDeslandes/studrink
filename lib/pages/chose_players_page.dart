import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/widgets/back_element_screen.dart';
import 'package:ptit_godet/widgets/pre_game/add_player_button.dart';
import 'package:ptit_godet/widgets/pre_game/fab_camera.dart';
import 'package:ptit_godet/widgets/pre_game/player_field.dart';
import 'package:ptit_godet/widgets/simple_title_screen.dart';

class ChosePlayersPage extends CupertinoPage {
  const ChosePlayersPage()
      : super(
            child: const ChosePlayersScreen(),
            key: const ValueKey<String>("/chose_players"));
}

class ChosePlayersScreen extends BackElementScreen with SimpleTitleScreen {
  const ChosePlayersScreen();

  @override
  String backButtonText() {
    return "Choix de la partie";
  }

  @override
  Widget body(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final maxHeight = constraints.maxHeight;
            return Container(
              height: maxHeight - 68.0, // size of validate button
              child: Column(
                children: [
                  Flexible(
                    child: BlocBuilder<CurrentGameBloc, CurrentGameState>(
                        builder: (context, state) {
                      final playerList = state.playerList;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            const padding = 30.0;
                            final player = playerList[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: padding, right: padding),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: PlayerField(player),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: FabCamera(player: player))
                                ],
                              ),
                            );
                          },
                          itemCount: playerList.length);
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Center(child: const AddPlayerButton()),
                  )
                ],
              ),
            );
          },
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: FlatButton(
                child: Text("Valider"),
                onPressed: () {
                  context.bloc<CurrentGameBloc>().add(const ValidateGame());
                }))
      ],
    );
  }

  @override
  String titleContent() {
    return "Joueurs";
  }
}
