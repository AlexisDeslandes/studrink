import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/widgets/bottom_button.dart';

class PlayerChallengeArea extends StatelessWidget {
  const PlayerChallengeArea();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BottomButton(
                  text: "Raté",
                  onPressed: () {
                    context
                        .read<CurrentGameBloc>()
                        .add(const FailChallenge());
                  },
                ),
                BottomButton(
                  text: "Réussi",
                  onPressed: () {
                    context
                        .read<CurrentGameBloc>()
                        .add(const SucceedChallenge());
                  },
                )
              ],
            ),
            alignment: Alignment.bottomCenter)
      ],
    );
  }
}
