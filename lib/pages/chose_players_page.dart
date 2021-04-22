import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/widgets/base_screen.dart';
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
  Widget? floatingActionButton(BuildContext context) => FloatingActionButton(
      child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              gradient: LinearGradient(colors: [
                Theme.of(context).accentColor,
                Theme.of(context).primaryColor
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Icon(Icons.play_arrow, color: Colors.white)),
      onPressed: () =>
          context.read<CurrentGameBloc>().add(const ValidateGame())); //todo name not empty

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: BlocBuilder<CurrentGameBloc, CurrentGameState>(
              builder: (context, state) {
            final playerList = state.playerList;
            return Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GlassWidget(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...playerList.map((player) => ListTile(
                                title: PlayerField(player),
                                leading: FabCamera(player: player),
                                trailing: FloatingActionButton(
                                    child:
                                        Icon(Icons.delete, color: Colors.black),
                                    mini: true,
                                    onPressed: () => context
                                        .read<CurrentGameBloc>()
                                        .add(RemovePlayer(player))),
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Center(child: const AddPlayerButton()),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
