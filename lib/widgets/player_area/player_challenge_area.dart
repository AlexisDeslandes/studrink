import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/widgets/bottom_button.dart';
import 'package:ptit_godet/widgets/buttons/color_button.dart';
import 'package:ptit_godet/widgets/buttons/white_button.dart';

class PlayerChallengeArea extends StatelessWidget {
  const PlayerChallengeArea();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        WhiteButton(
          text: "Raté",
          mini: true,
          callback: () {
            context.read<CurrentGameBloc>().add(const FailChallenge());
          },
        ),
        ColorButton(
          text: "Réussi",
          mini: true,
          callback: () {
            context.read<CurrentGameBloc>().add(const SucceedChallenge());
          },
        )
      ],
    );
  }
}
