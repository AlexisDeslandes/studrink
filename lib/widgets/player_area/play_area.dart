import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/pages/recap_game_page.dart';
import 'package:ptit_godet/widgets/player_area/player_challenge_area.dart';
import 'package:ptit_godet/widgets/player_area/player_chose_direction_area.dart';
import 'package:ptit_godet/widgets/player_area/player_chose_player_won_area.dart';
import 'package:ptit_godet/widgets/player_area/player_end_area.dart';
import 'package:ptit_godet/widgets/player_area/player_moving_area.dart';
import 'package:ptit_godet/widgets/player_area/player_ready_area.dart';
import 'package:ptit_godet/widgets/player_area/player_return_previous_checkpoint_area.dart';

class PlayArea extends StatelessWidget {
  const PlayArea({Key? key, required this.animationController})
      : super(key: key);

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
            height: 70.0,
            child: Stack(children: [
              BlocBuilder<CurrentGameBloc, CurrentGameState>(
                  buildWhen: (previous, current) =>
                      (previous.currentPlayer != current.currentPlayer) ||
                      (previous.currentPlayer?.state !=
                          current.currentPlayer?.state),
                  builder: (context, state) => AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: Container(
                            key: ValueKey(state.currentPlayer),
                            child: _getArea(state)),
                      )),
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FloatingActionButton(
                          mini: true,
                          heroTag: "recap",
                          child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                  gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).accentColor,
                                        Theme.of(context).primaryColor
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                              child:
                                  Icon(Icons.not_listed_location_rounded, color: Colors.white)),
                          onPressed: () {
                            animationController
                                .reverse()
                                .then((value) => _navToRecap(context));
                          })))
            ])));
  }

  void _navToRecap(BuildContext context) => context.read<NavBloc>().add(PushNav(
        pageBuilder: (_) => const RecapGamePage(),
        onPop: () => animationController.forward(),
      ));

  Widget _getArea(CurrentGameState state) {
    final currentPlayer = state.currentPlayer,
        currentPlayerState = currentPlayer!.state,
        actualCell = state.actualCell;
    if (actualCell == null) {
      return const SizedBox();
    }
    if ([PlayerState.ready, PlayerState.throwDice]
        .contains(currentPlayerState)) {
      return const PlayerReadyArea();
    } else if ([
      PlayerState.canEnd,
      PlayerState.preTurnLost,
      PlayerState.turnLost,
      PlayerState.thrownDice
    ].contains(currentPlayerState)) {
      return const PlayerEndArea();
    } else if (currentPlayerState == PlayerState.returnPreviousCheckPoint) {
      return const PlayerReturnPreviousCheckPointArea();
    } else if (currentPlayerState == PlayerState.moving) {
      return PlayerMovingArea(actualCell.moving!);
    } else if (currentPlayerState == PlayerState.selfChallenge) {
      return const PlayerChallengeArea();
    } else if (currentPlayerState == PlayerState.choseDirection) {
      return const PlayerChoseDirectionArea();
    } else if (currentPlayerState == PlayerState.waitForWinner) {
      return PlayerChosePlayerWonArea(
          currPlayer: state.currentPlayer!, opponent: state.currentOpponent!);
    } else if (currentPlayerState == PlayerState.chosePlayerMoving) {
      if (state.playerListAbleToMove().isEmpty) return const PlayerEndArea();
    } else if (currentPlayerState == PlayerState.stealConditionKey) {
      if (state.playerListAbleToBeStolen().isEmpty)
        return const PlayerEndArea();
    }
    return const SizedBox();
  }
}
