import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/widgets/base_screen.dart';
import 'package:ptit_godet/widgets/buttons/color_button.dart';
import 'package:ptit_godet/widgets/glass/glass_widget.dart';
import 'package:ptit_godet/widgets/recap_player_list_tile.dart';

class FinishGamePage extends CupertinoPage {
  const FinishGamePage()
      : super(
            key: const ValueKey("/finish_game"),
            child: const FinishGameScreen());
}

class FinishGameScreen extends StatefulWidget {
  const FinishGameScreen();

  @override
  State<StatefulWidget> createState() => FinishGameScreenState();
}

class FinishGameScreenState extends BaseScreenState {
  @override
  Duration get duration => Duration(milliseconds: 900);

  @override
  String get subTitle => "Fin de la partie";

  @override
  String get title => "Terminé";

  @override
  Widget backButton(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<CurrentGameBloc, CurrentGameState>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        final playerListInWinOrder = state.playerListInWinOrder;
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: FadeTransition(
                  opacity:
                      controller.drive(CurveTween(curve: Interval(0.5, 2 / 3))),
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        final player = playerListInWinOrder[index];
                        return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 5.0),
                            child: GlassWidget(
                                radius: 18,
                                child: RecapPlayerListTile(
                                    player: player, index: index)));
                      },
                      itemCount: state.playerList.length),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: ScaleTransition(
                scale: controller
                    .drive(CurveTween(
                        curve: Interval(
                      2 / 3,
                      1.0,
                    )))
                    .drive(TweenSequence([
                      TweenSequenceItem(
                          tween: Tween(begin: 0.0, end: 1.3), weight: 0.7),
                      TweenSequenceItem(
                          tween: Tween(begin: 1.3, end: 1.0), weight: 0.3)
                    ])),
                child: ColorButton(
                    callback: () {
                      context.read<CurrentGameBloc>().add(ResetGame());
                      controller.reverse().then((value) =>
                          context.read<NavBloc>().add(const ResetNavToHome()));
                    },
                    text: "Encore ?"),
              ),
            )
          ],
        );
      },
    );
  }
}
