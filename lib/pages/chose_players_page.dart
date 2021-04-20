import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/widgets/base_screen.dart';
import 'package:ptit_godet/widgets/buttons/color_button.dart';
import 'package:ptit_godet/widgets/glass/glass_widget.dart';
import 'package:ptit_godet/widgets/pre_game/add_player_button.dart';
import 'package:ptit_godet/widgets/pre_game/fab_camera.dart';
import 'package:ptit_godet/widgets/pre_game/player_field.dart';

class ChosePlayersPage extends CupertinoPage {
  const ChosePlayersPage()
      : super(
            child: const ChosePlayersScreen(),
            key: const ValueKey<String>("/chose_players"));
}

class ChosePlayersScreen extends StatefulWidget {
  const ChosePlayersScreen();

  @override
  State<StatefulWidget> createState() => ChosePlayersScreenState();
}

class ChosePlayersScreenState extends BaseScreenState {
  @override
  String get subTitle => "Ajouter des joueurs";

  @override
  String get title => "Joueurs";

  Widget backButton(BuildContext context) => BackButton(
      onPressed: () => backButtonCallback(context), color: Colors.black);

  Future<bool> backButtonCallback(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Avertissement",
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Text(
                "Etes-vous sûr de vouloir quitter la partie courante ? La progression sera perdue.",
                style: Theme.of(context).textTheme.bodyText1),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(ctx, false);
                  },
                  child: Text("NON",
                      style: TextStyle(color: Theme.of(context).primaryColor))),
              TextButton(
                  onPressed: () {
                    context.read<CurrentGameBloc>().add(ResetPlayerGame());
                    context.read<NavBloc>().add(const PopNav());
                    Navigator.pop(ctx, true);
                  },
                  child: Text("OUI", style: TextStyle(color: Colors.black)))
            ],
          );
        });
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Flexible(
                child: BlocBuilder<CurrentGameBloc, CurrentGameState>(
                    builder: (context, state) {
                  final playerList = state.playerList;
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: GlassWidget(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final player = playerList[index];
                            return ListTile(
                              title: PlayerField(player),
                              trailing: Wrap(
                                children: [
                                  FabCamera(player: player),
                                  FloatingActionButton(
                                      child: Icon(Icons.delete,
                                          color: Colors.black),
                                      mini: true,
                                      onPressed: () => context
                                          .read<CurrentGameBloc>()
                                          .add(RemovePlayer(player)))
                                ],
                              ),
                            );
                          },
                          itemCount: playerList.length),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Center(child: const AddPlayerButton()),
              )
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: ColorButton(
                text: "Valider",
                callback: () =>
                    context.read<CurrentGameBloc>().add(const ValidateGame())))
      ],
    );
  }
}
