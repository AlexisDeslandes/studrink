import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/widgets/buttons/color_button.dart';

class PlayerEndArea extends StatelessWidget {
  const PlayerEndArea();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ColorButton(
      text: "Terminer",
      callback: () {
        context.read<CurrentGameBloc>().add(const SwitchToOtherPlayer());
      },
    ));
  }
}
