import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/widgets/bottom_button.dart';

class PlayerReturnPreviousCheckPointArea extends StatelessWidget {
  const PlayerReturnPreviousCheckPointArea();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
            child: BottomButton(
              text: "Retour en arrière.",
              onPressed: () {
                context.bloc<CurrentGameBloc>().add(const ReturnPreviousCheckpoint());
              },
            ),
            alignment: Alignment.bottomCenter
        )
      ],
    );
  }
}
