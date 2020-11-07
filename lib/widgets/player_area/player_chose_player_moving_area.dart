import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/widgets/bottom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerChosePlayerMovingArea extends StatelessWidget {
  final List<Player> playerList;
  final PageController pageController;

  PlayerChosePlayerMovingArea(this.playerList)
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
                            .bloc<CurrentGameBloc>()
                            .add(MakePlayerMoving(player));
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
