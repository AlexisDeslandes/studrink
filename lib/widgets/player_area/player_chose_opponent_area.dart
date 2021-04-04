import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/widgets/bottom_button.dart';

class PlayerChoseOpponentArea extends StatelessWidget {
  final List<Player> playerList;
  final PageController pageController;

  PlayerChoseOpponentArea(this.playerList)
      : pageController = PageController(viewportFraction: 0.3, initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
            child: PageView.builder(
                controller: pageController,
                itemBuilder: (context, index) {
                  final player = playerList[index];
                  return Center(
                    child: BottomButton(
                      text: player.name,
                      onPressed: () {
                        context
                            .read<CurrentGameBloc>()
                            .add(PickOpponent(player));
                      },
                    ),
                  );
                },
                itemCount: playerList.length),
            alignment: Alignment.bottomCenter)
      ],
    );
  }
}
