import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';

class PlayerAnnouncer extends StatelessWidget {
  const PlayerAnnouncer();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentGameBloc, CurrentGameState>(
        builder: (context, state) {
          return Text("C'est au tour de ${state.currentPlayer.name}.");
        },
        buildWhen: (previous, current) =>
            previous.currentPlayer.name != current.currentPlayer.name);
  }
}
