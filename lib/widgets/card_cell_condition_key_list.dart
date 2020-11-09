import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/focused_cell_bloc/focused_cell_bloc.dart';
import 'package:ptit_godet/models/cell.dart';

class CardCellConditionKeyList extends StatelessWidget {
  final Cell cell;

  const CardCellConditionKeyList(this.cell);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FocusedCellBloc, FocusedCellState>(
        builder: (context, state) {
      if (state.cell != cell) {
        return Container();
      }
      final selectedPlayer = state.selectedPlayer;
      if (selectedPlayer != null) {
        final conditionKeyList = selectedPlayer.conditionKeyList;
        if (conditionKeyList.length == 0) {
          return Text("Aucun objectifs obtenus.",
              style: Theme.of(context).textTheme.caption);
        }
        const spacing = 10.0;
        return Wrap(
          direction: Axis.vertical,
          runSpacing: spacing,
          spacing: spacing,
          children: conditionKeyList
              .map((conditionKey) => Text(conditionKey.name,
                  style: Theme.of(context).textTheme.caption))
              .toList(),
        );
      }
      return Container();
    });
  }
}
