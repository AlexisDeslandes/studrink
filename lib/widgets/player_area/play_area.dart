import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/widgets/player_area/player_challenge_area.dart';
import 'package:ptit_godet/widgets/player_area/player_chose_direction_area.dart';
import 'package:ptit_godet/widgets/player_area/player_chose_opponent_area.dart';
import 'package:ptit_godet/widgets/player_area/player_chose_player_won_area.dart';
import 'package:ptit_godet/widgets/player_area/player_end_area.dart';
import 'package:ptit_godet/widgets/player_area/player_moving_area.dart';
import 'package:ptit_godet/widgets/player_area/player_ready_area.dart';
import 'package:ptit_godet/widgets/player_area/player_return_previous_checkpoint_area.dart';

class PlayArea extends StatelessWidget {
  const PlayArea();

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
            if ([PlayerState.ready, PlayerState.throwDice]
                .contains(state.currentPlayer.state)) {
              return const PlayerReadyArea();
            } else if ([
              PlayerState.canEnd,
              PlayerState.preTurnLost,
              PlayerState.turnLost,
              PlayerState.thrownDice
            ].contains(state.currentPlayer.state)) {
              return const PlayerEndArea();
            } else if (state.currentPlayer.state ==
                PlayerState.returnPreviousCheckPoint) {
              return const PlayerReturnPreviousCheckPointArea();
            } else if (state.currentPlayer.state == PlayerState.moving) {
              return PlayerMovingArea(state.currentCell.moving);
            } else if (state.currentPlayer.state == PlayerState.selfChallenge) {
              return const PlayerChallengeArea();
            } else if (state.currentPlayer.state ==
                PlayerState.choseDirection) {
              return const PlayerChoseDirectionArea();
            } else if (state.currentPlayer.state == PlayerState.choseOpponent) {
              return PlayerChoseOpponentArea(state.playerList
                  .where((element) => state.currentPlayer != element)
                  .toList());
            } else if (state.currentPlayer.state == PlayerState.waitForWinner) {
              return PlayerChosePlayerWonArea(
                  [state.currentPlayer, state.currentOpponent]);
            }
            return Container();
          },
        ));
  }
}
