import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/widgets/base_screen.dart';
import 'package:ptit_godet/widgets/buttons/color_button.dart';
import 'package:ptit_godet/widgets/glass/glass_widget.dart';
import 'package:ptit_godet/widgets/player_avatar.dart';

class FinishGamePage extends CupertinoPage {
  const FinishGamePage()
      : super(
            key: const ValueKey("/finish_game"),
            child: const FinishGameScreen());
}

class FinishGameScreen extends StatefulWidget {
  const FinishGameScreen();

  @override
  State<StatefulWidget> createState() => FinishGameScreenState();
}

class FinishGameScreenState extends BaseScreenState {
  @override
  String get subTitle => "Fin de la partie";

  @override
  String get title => "Terminé";

  @override
  Widget backButton(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<CurrentGameBloc, CurrentGameState>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        final playerListInWinOrder = state.playerListInWinOrder;
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      final player = playerListInWinOrder[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 5.0),
                        child: GlassWidget(
                          radius: 18,
                          child: ListTile(
                            leading: PlayerAvatar(player: player),
                            title: Text(
                              player.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400),
                            ),
                            subtitle: Text(
                              "Cellule n°${player.idCurrentCell + 1}",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            trailing: Text(
                                "${index + 1}${index == 0 ? "er" : "è"}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(fontSize: 24)),
                          ),
                        ),
                      );
                    },
                    itemCount: state.playerList.length),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: ColorButton(
                  callback: () {
                    context.read<CurrentGameBloc>().add(ResetGame());
                    context.read<NavBloc>().add(const ResetNavToHome());
                  },
                  text: "Encore ?"),
            )
          ],
        );
      },
    );
  }
}

/*
ListTile(
              leading: PlayerAvatar(player: selectedPlayer),
              title: Text(
                selectedPlayer.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 24, fontWeight: FontWeight.w400),
              ),
              subtitle: Text(
                "$conditionCount objectif(s).",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            );

            Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: size.width / 3,
                    height: size.width / 3,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(100),
                      child: ClipOval(
                          child: winner.avatar != null
                              ? Image.memory(winner.avatar!)
                              : Container(
                                  color: winner.color, width: 30, height: 30)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Text("${winner.name} a gagné.",
                        style: Theme.of(context).textTheme.bodyText2),
                  )
                ],
              )

 */
