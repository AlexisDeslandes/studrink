import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/widgets/condition_widget.dart';

class PlayerAnnouncer extends StatelessWidget {
  const PlayerAnnouncer();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentGameBloc, CurrentGameState>(
        builder: (context, state) {
          final name = state.currentPlayer!.name,
              wrappedSubtitle = Align(
                  key: ValueKey(name),
                  alignment: Alignment.centerLeft,
                  child:
                      Text(name, style: Theme.of(context).textTheme.titleSmall));
          return Row(children: [
            Text("C'est au tour de ",
                style: Theme.of(context).textTheme.titleSmall),
            ConditionWidget(
                appear: !kIsWeb,
                appearWidgetCallback: () => AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    switchInCurve: Interval(0.5, 1.0),
                    switchOutCurve: Interval(0.0, 0.5),
                    transitionBuilder: (child, animation) {
                      return ClipRRect(
                          child: FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                  position: animation.drive(Tween(
                                      begin: Offset(0.0, 1.0),
                                      end: Offset(0.0, 0.0))),
                                  child: child)));
                    },
                    child: wrappedSubtitle),
                replaceWidgetCallback: () => wrappedSubtitle)
          ]);
        },
        buildWhen: (previous, current) =>
            previous.currentPlayer?.name != current.currentPlayer?.name);
  }
}
