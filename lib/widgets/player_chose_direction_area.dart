import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/widgets/bottom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerChoseDirectionArea extends StatelessWidget {
  const PlayerChoseDirectionArea();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BottomButton(
                  text: "Avancer",
                  onPressed: () {
                    context
                        .bloc<CurrentGameBloc>()
                        .add(const MovingForward());
                  },
                ),
                BottomButton(
                  text: "Reculer",
                  onPressed: () {
                    context
                        .bloc<CurrentGameBloc>()
                        .add(const MoveBack());
                  },
                )
              ],
            ),
            alignment: Alignment.bottomCenter)
      ],
    );
  }
}
