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
    final state = context.bloc<CurrentGameBloc>().state;
    final cells = state.boardGame.cells;
    return BlocListener<CurrentGameBloc, CurrentGameState>(
        listener: (context, state) => context
            .bloc<GamePageViewBloc>()
            .add(ChangePageView(state.currentPlayer.idCurrentCell)),
        listenWhen: _currentPlayerChangedCell,
        child: PageView.builder(
            onPageChanged: (value) {
              context.bloc<FocusedCellBloc>().add(ChangeFocusedCell(
                  cell: context.bloc<CurrentGameBloc>().state.currentCell,
                  playerList: context
                      .bloc<CurrentGameBloc>()
                      .state
                      .playerListFromCell(value)));
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
