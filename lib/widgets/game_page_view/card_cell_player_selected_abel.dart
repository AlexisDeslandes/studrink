import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/blocs/focused_cell_bloc/focused_cell_bloc.dart';
import 'package:studrink/models/cell.dart';

class CardCellPlayerSelectedLabel extends StatelessWidget {
  final Cell cell;

  const CardCellPlayerSelectedLabel(this.cell);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentGameBloc, CurrentGameState>(
        builder: (context, currentGameState) {
      return BlocBuilder<FocusedCellBloc, FocusedCellState>(
          builder: (context, state) {
        final playersOnCell = currentGameState.playerListFromCell(cell);
        final selectedPlayer = state.selectedPlayer;
        if (selectedPlayer != null && playersOnCell.contains(selectedPlayer)) {
          return Text(state.selectedPlayer?.name ?? "",
              style: Theme.of(context).textTheme.bodyMedium);
        }
        return Container();
      });
    });
  }
}
