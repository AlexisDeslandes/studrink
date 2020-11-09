import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/focused_cell_bloc/focused_cell_bloc.dart';

class CardCellConditionKeyList extends StatelessWidget {
  const CardCellConditionKeyList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FocusedCellBloc, FocusedCellState>(
        builder: (context, state) {
      final selectedPlayer = state.selectedPlayer;
      if (selectedPlayer != null) {
        final conditionKeyList = selectedPlayer.conditionKeyList;
        if (conditionKeyList.length == 0) {
          return Text("Aucun objectifs obtenus.",
              style: Theme.of(context).textTheme.caption);
        }
        const spacing = 10.0;
        return Wrap(
          direction: Axis.horizontal,
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
