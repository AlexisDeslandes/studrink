import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studrink/blocs/dice/dice_bloc.dart';

class DiceView extends StatelessWidget {
  const DiceView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<DiceBloc, DiceState>(
          builder: (context, state) {
            final diceValue = state.diceValue;
            if (diceValue > 0)
              return Image.asset("assets/icons/dice_$diceValue.png");
            return const SizedBox();
          },
          buildWhen: (previous, current) =>
              previous.diceValue != current.diceValue),
    );
  }
}
