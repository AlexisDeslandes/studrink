import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/widgets/bottom_button.dart';

class PlayerChosePlayerWonArea extends StatelessWidget {
  final List<Player> playerList;

  const PlayerChosePlayerWonArea(this.playerList);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Text("Choisis le vainqueur."),
        ),
        Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: playerList
                  .map((e) => BottomButton(
                        text: e.name,
                        onPressed: () {
                          context.read<CurrentGameBloc>().add(ChoseWinner(e));
                        },
                      ))
                  .toList(),
            ),
            alignment: Alignment.bottomCenter)
      ],
    );
  }
}
