import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ptit_godet/blocs/focused_cell_bloc/focused_cell_bloc.dart';

class UserDiceView extends StatelessWidget {
  const UserDiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FocusedCellBloc, FocusedCellState>(
        builder: (context, state) {
          final lastDiceValue = state.selectedPlayer!.lastDiceValue;
          if (lastDiceValue > 0)
            return SvgPicture.asset("assets/icons/dice_$lastDiceValue.svg",
                width: 40);
          return const SizedBox();
        },
        buildWhen: (previous, current) =>
            previous.selectedPlayer!.lastDiceValue !=
            current.selectedPlayer!.lastDiceValue);
  }
}
