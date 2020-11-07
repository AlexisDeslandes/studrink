import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/widgets/bottom_button.dart';

class PlayerReadyArea extends StatelessWidget {
  const PlayerReadyArea();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          child: BottomButton(
            text: "Lancer dé",
            onPressed: () {
              context.bloc<CurrentGameBloc>().add(const ThrowDice());
            },
          ),
          alignment: Alignment.bottomCenter
        )
      ],
    );
  }
}
