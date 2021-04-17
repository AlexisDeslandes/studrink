import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/widgets/bottom_button.dart';
import 'package:ptit_godet/widgets/buttons/color_button.dart';
import 'package:ptit_godet/widgets/buttons/white_button.dart';

class PlayerChoseDirectionArea extends StatelessWidget {
  const PlayerChoseDirectionArea();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ColorButton(
            text: "Avancer",
            mini: true,
            callback: () {
              context.read<CurrentGameBloc>().add(const MovingForward());
            },
          ),
          WhiteButton(
            text: "Reculer",
            mini: true,
            callback: () {
              context.read<CurrentGameBloc>().add(const MoveBack());
            },
          )
        ],
      ),
    );
  }
}
