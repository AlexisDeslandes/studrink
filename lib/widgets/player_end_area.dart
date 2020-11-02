import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/widgets/bottom_button.dart';

class PlayerEndArea extends StatelessWidget {
  const PlayerEndArea();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
            child: BottomButton(
              text: "Terminer le tour",
              onPressed: () {
                context.bloc<CurrentGameBloc>().add(const SwitchToOtherPlayer());
              },
            ),
            alignment: Alignment.bottomCenter
        )
      ],
    );
  }
}
