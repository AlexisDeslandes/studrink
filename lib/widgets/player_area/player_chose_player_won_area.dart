import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/models/player.dart';
import 'package:studrink/widgets/buttons/color_button.dart';
import 'package:studrink/widgets/buttons/white_button.dart';

class PlayerChosePlayerWonArea extends StatelessWidget {
  const PlayerChosePlayerWonArea(
      {Key? key, required this.currPlayer, required this.opponent})
      : super(key: key);
  final Player currPlayer;
  final Player opponent;

  @override
  Widget build(BuildContext context) {
    void choseWinner(Player player) =>
        context.read<CurrentGameBloc>().add(ChoseWinner(player));
    return Column(
      children: [
        Text(
          "Choisis le vainqueur",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Wrap(
                  spacing: 8.0,
                  children: [
                    WhiteButton(
                        text: opponent.name,
                        mini: true,
                        callback: () => choseWinner(opponent)),
                    ColorButton(
                        text: currPlayer.name,
                        callback: () => choseWinner(currPlayer),
                        mini: true)
                  ]),
            ),
          ),
        )
      ],
    );
  }
}
