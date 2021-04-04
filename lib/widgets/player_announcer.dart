import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';

class PlayerAnnouncer extends StatelessWidget {
  const PlayerAnnouncer();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentGameBloc, CurrentGameState>(
        builder: (context, state) {
          final name = state.currentPlayer!.name;
          return Row(children: [
            Text("C'est au tour de "),
            Expanded(
                child: AnimatedSwitcher(
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
                                child: child))
                      );
                    },
                    child: Align(
                        key: ValueKey(name),
                        alignment: Alignment.centerLeft,
                        child: Text(name))))
          ]);
        },
        buildWhen: (previous, current) =>
            previous.currentPlayer?.name != current.currentPlayer?.name);
  }
}