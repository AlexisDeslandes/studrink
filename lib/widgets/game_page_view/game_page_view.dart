import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/focused_cell_bloc/focused_cell_bloc.dart';
import 'package:ptit_godet/blocs/game_page_view_bloc/game_page_view_bloc.dart';
import 'package:ptit_godet/widgets/game_page_view/card_cell.dart';

class GamePageView extends StatelessWidget {
  const GamePageView();

  @override
  Widget build(BuildContext context) {
    final pageController =
        context.read<GamePageViewBloc>().state.pageController;
    final cells = context.read<CurrentGameBloc>().state.boardGame!.cells;
    return BlocListener<CurrentGameBloc, CurrentGameState>(
        listener: (context, state) {
          context
              .read<GamePageViewBloc>()
              .add(ChangePageView(state.currentPlayer!.idCurrentCell));
        },
        listenWhen: _currentPlayerChangedCell,
        child: PageView.builder(
            onPageChanged: (value) {
              final currentGameBlocState =
                      context.read<CurrentGameBloc>().state,
                  playerListOnCell =
                      currentGameBlocState.playerListFromIdCell(value),
                  currentPlayer = currentGameBlocState.currentPlayer;
              if (playerListOnCell.contains(currentPlayer)) {
                context
                    .read<FocusedCellBloc>()
                    .add(ChangeFocusedPlayer(currentPlayer!));
              } else if (playerListOnCell.isNotEmpty) {
                context
                    .read<FocusedCellBloc>()
                    .add(ChangeFocusedPlayer(playerListOnCell[0]));
              }
            },
            itemBuilder: (context, index) {
              final cell = cells[index];
              return CardCell(cell: cell);
            },
            itemCount: cells.length,
            controller: pageController));
  }

  bool _currentPlayerChangedCell(
      CurrentGameState previous, CurrentGameState current) {
    return (previous.currentPlayer != current.currentPlayer) ||
        (previous.currentPlayer!.idCurrentCell !=
            current.currentPlayer!.idCurrentCell);
  }
}
