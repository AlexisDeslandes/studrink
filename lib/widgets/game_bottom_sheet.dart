import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/models/moving.dart';
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
          case PlayerState.chosePlayerMoving:
            final cells = state.boardGame!.cells,
                cellCount = cells.length,
                moving = state.currentCell!.moving!,
                movingCount = moving.movingType == MovingType.forward
                    ? moving.count
                    : -moving.count;

            return AppBottomSheet(
              getChild: (controller) => ChoseOpponentListView(
                  contentCallback: (player) => Text(
                      "Effets : ${cells[player.idCurrentCell + movingCount].effectsLabel}",
                      style: Theme.of(context).textTheme.bodyText1),
                  controller: controller,
                  playerList: state.playerList
                      .where((element) =>
                          state.currentPlayer != element &&
                          (element.idCurrentCell + movingCount) > 0 &&
                          (element.idCurrentCell + movingCount) < cellCount)
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
