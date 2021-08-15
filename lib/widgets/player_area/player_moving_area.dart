import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/models/moving.dart';
import 'package:studrink/widgets/buttons/color_button.dart';

class PlayerMovingArea extends StatelessWidget {
  final Moving moving;

  const PlayerMovingArea(this.moving);

  @override
  Widget build(BuildContext context) {
    final prefix =
        moving.movingType == MovingType.forward ? "Avance de" : "Recule de";
    return Center(
      child: ColorButton(
          text: "$prefix ${moving.count}",
          callback: () =>
              context.read<CurrentGameBloc>().add(const MovePlayer())),
    );
  }
}
