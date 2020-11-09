import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/focused_cell_bloc/focused_cell_bloc.dart';
import 'package:ptit_godet/blocs/game_page_view_bloc/game_page_view_bloc.dart';
import 'package:ptit_godet/widgets/card_cell.dart';

class GamePageView extends StatelessWidget {
  const GamePageView();

  @override
  Widget build(BuildContext context) {
    final pageController =
        context.bloc<GamePageViewBloc>().state.pageController;
    final cells = context.bloc<CurrentGameBloc>().state.boardGame.cells;
    return BlocListener<CurrentGameBloc, CurrentGameState>(
        listener: (context, state) => context
            .bloc<GamePageViewBloc>()
            .add(ChangePageView(state.currentPlayer.idCurrentCell)),
        listenWhen: _currentPlayerChangedCell,
        child: PageView.builder(
            onPageChanged: (value) {
              final playerListOnCell = context
                  .bloc<CurrentGameBloc>()
                  .state
                  .playerListFromIdCell(value);
              if (playerListOnCell.isNotEmpty) {
                context
                    .bloc<FocusedCellBloc>()
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
        (previous.currentPlayer.idCurrentCell !=
            current.currentPlayer.idCurrentCell);
  }
}
