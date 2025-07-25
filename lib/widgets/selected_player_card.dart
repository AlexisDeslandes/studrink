import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/blocs/focused_cell_bloc/focused_cell_bloc.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';
import 'package:studrink/widgets/player_avatar.dart';
import 'package:studrink/widgets/user_dice_view.dart';

class SelectedPlayerCard extends StatelessWidget {
  const SelectedPlayerCard();

  @override
  Widget build(BuildContext context) {
    return GlassWidget(
      child: BlocBuilder<FocusedCellBloc, FocusedCellState>(
          buildWhen: (previous, current) =>
              previous.selectedPlayer != current.selectedPlayer,
          builder: (context, state) {
            final selectedPlayer = state.selectedPlayer;
            if (selectedPlayer == null) return const SizedBox();
            final idCurrentCell = selectedPlayer.idCurrentCell,
                nextConditionKey = context
                    .read<CurrentGameBloc>()
                    .state
                    .nextConditionKey(idCurrentCell);
            var subTitle;
            if (nextConditionKey != null) {
              final conditionCount = selectedPlayer.conditionKeyList
                  .where((element) => element == nextConditionKey)
                  .length;
              subTitle = "$conditionCount ${nextConditionKey.name}(s)";
            } else {
              subTitle = "Fonce vers la victoire !";
            }
            return ListTile(
                leading: PlayerAvatar(player: selectedPlayer),
                title: Text(
                  selectedPlayer.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 24, fontWeight: FontWeight.w400),
                ),
                subtitle: Text(subTitle,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                trailing: const UserDiceView());
          }),
    );
  }
}
