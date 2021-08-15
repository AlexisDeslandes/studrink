import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/widgets/buttons/color_button.dart';

class PlayerReturnPreviousCheckPointArea extends StatelessWidget {
  const PlayerReturnPreviousCheckPointArea();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ColorButton(
      text: "Retour",
      callback: () {
        context.read<CurrentGameBloc>().add(const ReturnPreviousCheckpoint());
      },
    ));
  }
}
