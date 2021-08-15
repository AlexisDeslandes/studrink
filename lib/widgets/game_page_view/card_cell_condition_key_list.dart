import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/blocs/focused_cell_bloc/focused_cell_bloc.dart';
import 'package:studrink/models/cell.dart';

class CardCellConditionKeyList extends StatelessWidget {
  final Cell cell;

  const CardCellConditionKeyList(this.cell);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentGameBloc, CurrentGameState>(
        builder: (context, currentGameState) {
      return BlocBuilder<FocusedCellBloc, FocusedCellState>(
          builder: (context, state) {
        final playersOnCell = currentGameState.playerListFromCell(cell);
        final selectedPlayer = state.selectedPlayer;
        if (selectedPlayer != null && playersOnCell.contains(selectedPlayer)) {
          final conditionKeyLabels = selectedPlayer.conditionKeyLabels;
          if (conditionKeyLabels.length == 0) {
            return Text("Aucun objectifs obtenus.",
                style: Theme.of(context).textTheme.caption);
          }
          const spacing = 10.0;
          return Wrap(
            direction: Axis.vertical,
            runSpacing: spacing,
            spacing: spacing,
            children: conditionKeyLabels
                .map((conditionKey) => Text(conditionKey,
                    style: Theme.of(context).textTheme.caption))
                .toList(),
          );
        }
        return Container();
      });
    });
  }
}
