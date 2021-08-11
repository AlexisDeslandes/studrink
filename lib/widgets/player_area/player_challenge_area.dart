import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/widgets/buttons/color_button.dart';
import 'package:ptit_godet/widgets/buttons/white_button.dart';

class PlayerChallengeArea extends StatelessWidget {
  const PlayerChallengeArea();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Wrap(
          spacing: 8.0,
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
        ),
      ),
    );
  }
}
