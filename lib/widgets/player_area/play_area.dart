import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/widgets/player_area/player_challenge_area.dart';
import 'package:ptit_godet/widgets/player_area/player_chose_direction_area.dart';
import 'package:ptit_godet/widgets/player_area/player_chose_player_won_area.dart';
import 'package:ptit_godet/widgets/player_area/player_end_area.dart';
import 'package:ptit_godet/widgets/player_area/player_moving_area.dart';
import 'package:ptit_godet/widgets/player_area/player_ready_area.dart';
import 'package:ptit_godet/widgets/player_area/player_return_previous_checkpoint_area.dart';

class PlayArea extends StatelessWidget {
  const PlayArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      child: BlocBuilder<CurrentGameBloc, CurrentGameState>(
          buildWhen: (previous, current) =>
              (previous.currentPlayer != current.currentPlayer) ||
              (previous.currentPlayer?.state != current.currentPlayer?.state),
          builder: (context, state) => AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: Container(
                    key: ValueKey(state.currentPlayer), child: _getArea(state)),
              )),
    );
  }

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
