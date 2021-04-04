import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/models/moving.dart';
import 'package:ptit_godet/widgets/bottom_button.dart';

class PlayerMovingArea extends StatelessWidget {
  final Moving moving;

  const PlayerMovingArea(this.moving);

  @override
  Widget build(BuildContext context) {
    final prefix =
        moving.movingType == MovingType.forward ? "Avance de" : "Recule de";
    return Stack(
      children: [
        Align(
            child: BottomButton(
                text: "$prefix ${moving.count} cases.",
                onPressed: () =>
                    context.read<CurrentGameBloc>().add(const MovePlayer())),
            alignment: Alignment.bottomCenter)
      ],
    );
  }
}
