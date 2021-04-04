import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/focused_cell_bloc/focused_cell_bloc.dart';
import 'package:ptit_godet/models/cell.dart';

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
          return Wrap(
            runAlignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: playerList.map((player) {
              final hasFocus = focusedCellState.selectedPlayer == player;
              return GestureDetector(
                onTap: () => context
                    .read<FocusedCellBloc>()
                    .add(ChangeFocusedPlayer(player)),
                child: Container(
                  width: imageSize + borderRadius * 2,
                  height: imageSize + borderRadius * 2,
                  child: Center(
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        decoration: hasFocus
                            ? BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: borderRadius))
                            : null,
                        child: ClipOval(
                            child: player.avatar != null
                                ? Image.memory(player.avatar!, width: imageSize)
                                : Container(
                                    color: player.color,
                                    width: imageSize,
                                    height: imageSize)),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      );
    });
  }
}
