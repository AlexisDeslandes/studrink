import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/widgets/player_area/player_challenge_area.dart';
import 'package:ptit_godet/widgets/player_area/player_chose_direction_area.dart';
import 'package:ptit_godet/widgets/player_area/player_chose_opponent_area.dart';
import 'package:ptit_godet/widgets/player_area/player_chose_player_moving_area.dart';
import 'package:ptit_godet/widgets/player_area/player_chose_player_stole_area.dart';
import 'package:ptit_godet/widgets/player_area/player_chose_player_won_area.dart';
import 'package:ptit_godet/widgets/player_area/player_end_area.dart';
import 'package:ptit_godet/widgets/player_area/player_moving_area.dart';
import 'package:ptit_godet/widgets/player_area/player_ready_area.dart';
import 'package:ptit_godet/widgets/player_area/player_return_previous_checkpoint_area.dart';

class PlayArea extends StatelessWidget {
  final PageController pageController;

  const PlayArea(this.pageController);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: BlocBuilder<CurrentGameBloc, CurrentGameState>(
          buildWhen: (previous, current) {
            return (previous.currentPlayer != current.currentPlayer) ||
                (previous.currentPlayer.state != current.currentPlayer.state);
          },
          builder: (context, state) {
            final currentPlayerState = state.currentPlayer.state;
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
            } else if (currentPlayerState ==
                PlayerState.returnPreviousCheckPoint) {
              return const PlayerReturnPreviousCheckPointArea();
            } else if (currentPlayerState == PlayerState.moving) {
              return PlayerMovingArea(state.currentCell.moving);
            } else if (currentPlayerState == PlayerState.selfChallenge) {
              return const PlayerChallengeArea();
            } else if (currentPlayerState == PlayerState.choseDirection) {
              return const PlayerChoseDirectionArea();
            } else if (currentPlayerState == PlayerState.choseOpponent) {
              return PlayerChoseOpponentArea(state.playerList
                  .where((element) => state.currentPlayer != element)
                  .toList());
            } else if (currentPlayerState == PlayerState.waitForWinner) {
              return PlayerChosePlayerWonArea(
                  [state.currentPlayer, state.currentOpponent]);
            } else if (currentPlayerState == PlayerState.chosePlayerMoving) {
              return PlayerChosePlayerMovingArea(
                  state.playerList
                      .where((element) => element != state.currentPlayer)
                      .toList(),
                  pageController);
            } else if (currentPlayerState == PlayerState.stealConditionKey) {
              final conditionKey = state.currentCell.conditionKeyStolen;
              final playerHavingConditionKey = state.playerList
                  .where((element) =>
                      element != state.currentPlayer &&
                      element.conditionKeyList.contains(conditionKey))
                  .toList();
              if (playerHavingConditionKey.length == 0) {
                return const PlayerEndArea();
              }
              return PlayerChosePlayerStoleArea(
                  playerHavingConditionKey, pageController);
            }
            return Container();
          },
        ));
  }
}
