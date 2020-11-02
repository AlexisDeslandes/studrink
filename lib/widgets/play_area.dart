import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/widgets/player_end_area.dart';
import 'package:ptit_godet/widgets/player_moving_area.dart';
import 'package:ptit_godet/widgets/player_ready_area.dart';
import 'package:ptit_godet/widgets/player_return_previous_checkpoint_area.dart';

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
            if (state.currentPlayer.state == PlayerState.ready) {
              return const PlayerReadyArea();
            } else if ([
              PlayerState.canEnd,
              PlayerState.preTurnLost,
              PlayerState.turnLost
            ].contains(state.currentPlayer.state)) {
              return const PlayerEndArea();
            } else if (state.currentPlayer.state ==
                PlayerState.returnPreviousCheckPoint) {
              return const PlayerReturnPreviousCheckPointArea();
            } else if (state.currentPlayer.state == PlayerState.moving) {
              return PlayerMovingArea(state.currentCell.moving);
            }
            return Container();
          },
        ));
  }
}
