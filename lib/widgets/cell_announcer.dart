import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';

class CellAnnouncer extends StatelessWidget {
  const CellAnnouncer();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentGameBloc, CurrentGameState>(
        builder: (context, state) {
          final name = state.currentCellName;
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              switchInCurve: Interval(0.5, 1.0),
              switchOutCurve: Interval(0.0, 0.5),
              transitionBuilder: (child, animation) {
                return ClipRRect(
                    child: FadeTransition(
                        opacity: animation,
                        child: child));
              },
              child: Align(
                  key: ValueKey(name),
                  alignment: Alignment.centerLeft,
                  child: Text(name,
                      style: Theme.of(context).textTheme.headline1)));
        },
        buildWhen: (previous, current) =>
            previous.currentCellName != current.currentCellName);
  }
}
