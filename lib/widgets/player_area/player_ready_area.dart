import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/widgets/buttons/color_button.dart';

class PlayerReadyArea extends StatelessWidget {
  const PlayerReadyArea();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ColorButton(
        text: "Lancer dé",
        callback: () {
          context.read<CurrentGameBloc>().add(const ThrowDice());
        },
      ),
    );
  }
}
