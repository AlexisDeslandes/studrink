import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/dice/dice_bloc.dart';

class DiceView extends StatelessWidget {
  const DiceView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<DiceBloc, DiceState>(builder: (context, state) {
        final diceValue = state.diceValue;
        if (diceValue > 0) {
          return Text(state.diceValue.toString(),
              style: Theme.of(context).textTheme.headline1);
        }
        return Container();
      }),
    );
  }
}
