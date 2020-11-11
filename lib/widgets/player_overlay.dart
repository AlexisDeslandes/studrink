import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';

class PlayerOverlay extends StatelessWidget {
  const PlayerOverlay();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 1 / 2;
    return Center(
      child: BlocBuilder<CurrentGameBloc, CurrentGameState>(
          buildWhen: (previous, current) =>
              previous.currentPlayer.name != current.currentPlayer.name,
          builder: (context, state) => AnimatedSwitcher(
                switchOutCurve: Interval(0.0, 0.0),
                duration: Duration(milliseconds: 1300),
                transitionBuilder: (child, animation) => SlideTransition(
                  position: animation.drive(
                      Tween(begin: Offset(0.0, 0.2), end: Offset(0.0, -0.2))),
                  child: FadeTransition(
                      opacity: animation.drive(TweenSequence([
                        TweenSequenceItem(
                            tween: Tween(begin: 0.0, end: 1.0), weight: 0.5),
                        TweenSequenceItem(
                            tween: Tween(begin: 1.0, end: 0.0), weight: 0.5)
                      ])),
                      child: child),
                ),
                child: Card(
                    key: ValueKey(state.currentPlayer.name),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white,
                                  Theme.of(context).primaryColor
                                ])),
                        child: Column(children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(100),
                                child: ClipOval(
                                    child: Image.memory(
                                        state.currentPlayer.avatar))),
                          )),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Text("${state.currentPlayer.name}"),
                          )
                        ]))),
              )),
    );
  }
}
