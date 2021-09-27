import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';

class TurnIndicator extends StatelessWidget {
  const TurnIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentGameBloc, CurrentGameState>(
        buildWhen: (previous, current) => previous.turnCount != current.turnCount,
        builder: (context, state) => Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GlassWidget(
                padding: EdgeInsets.all(8.0),
                child: Text("Tour n°${state.turnCount}",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 16)),
              ),
            ));
  }
}
