import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/blocs/focused_cell_bloc/focused_cell_bloc.dart';
import 'package:studrink/models/cell.dart';
import 'package:studrink/widgets/player_avatar.dart';

class CardCellPlayerList extends StatelessWidget {
  final Cell cell;

  const CardCellPlayerList(this.cell);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentGameBloc, CurrentGameState>(
        builder: (context, currentGameState) {
      return BlocBuilder<FocusedCellBloc, FocusedCellState>(
        builder: (context, focusedCellState) {
          const imageSize = 40.0, borderRadius = 3.0;
          final playerList = currentGameState.playerListFromCell(cell);
          return Row(children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: playerList.length,
                itemBuilder: (context, index) {
                  final player = playerList[index];
                  final hasFocus = focusedCellState.selectedPlayer == player;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: GestureDetector(
                      onTap: () => context
                          .read<FocusedCellBloc>()
                          .add(ChangeFocusedPlayer(player)),
                      child: Container(
                        width: imageSize + borderRadius * 2,
                        height: imageSize + borderRadius * 2,
                        child: Center(
                          child: PlayerAvatar(
                              player: player,
                              decoration: hasFocus
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white,
                                          width: borderRadius))
                                  : null),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ]);
        },
      );
    });
  }
}
