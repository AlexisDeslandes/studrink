import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:ptit_godet/widgets/bottom_sheet/chose_opponent_list_view.dart';

class GameBottomSheet extends StatelessWidget {
  const GameBottomSheet();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentGameBloc, CurrentGameState>(
      buildWhen: (previous, current) =>
          previous.currentPlayer?.state != current.currentPlayer?.state,
      builder: (context, state) {
        final currentPlayerState = state.currentPlayer!.state;
        switch (currentPlayerState) {
          case PlayerState.ready:
            // TODO: Handle this case.
            break;
          case PlayerState.canEnd:
            // TODO: Handle this case.
            break;
          case PlayerState.returnPreviousCheckPoint:
            // TODO: Handle this case.
            break;
          case PlayerState.moving:
            // TODO: Handle this case.
            break;
          case PlayerState.preTurnLost:
            // TODO: Handle this case.
            break;
          case PlayerState.turnLost:
            // TODO: Handle this case.
            break;
          case PlayerState.throwDice:
            // TODO: Handle this case.
            break;
          case PlayerState.thrownDice:
            // TODO: Handle this case.
            break;
          case PlayerState.selfChallenge:
            // TODO: Handle this case.
            break;
          case PlayerState.choseDirection:
            // TODO: Handle this case.
            break;
          case PlayerState.choseOpponent:
            return AppBottomSheet(
                getChild: (controller) => ChoseOpponentListView(
                    callback: (player) => context
                        .read<CurrentGameBloc>()
                        .add(PickOpponent(player)),
                    controller: controller,
                    playerList: state.playerList
                        .where((element) => state.currentPlayer != element)
                        .toList()));
          case PlayerState.waitForWinner:
            // TODO: Handle this case.
            break;
          case PlayerState.chosePlayerMoving:
            return AppBottomSheet(
              getChild: (controller) => ChoseOpponentListView(
                  controller: controller,
                  playerList: state.playerList
                      .where((element) => state.currentPlayer != element)
                      .toList(),
                  callback: (player) => context
                      .read<CurrentGameBloc>()
                      .add(MakePlayerMoving(player))),
            );
          case PlayerState.stealConditionKey:
            // TODO: Handle this case.
            break;
          default:
            return const SizedBox();
        }
        return const SizedBox();
      },
    );
  }
}
