import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/utils/studrink_utils.dart';
import 'package:studrink/widgets/buttons/color_button.dart';
import 'package:studrink/widgets/buttons/white_button.dart';

class PlayerChallengeArea extends StatelessWidget {
  const PlayerChallengeArea();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Wrap(
          spacing: isTablet(context) ? 20.0 : 8.0,
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
