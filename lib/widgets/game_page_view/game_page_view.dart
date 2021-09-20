import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/blocs/focused_cell_bloc/focused_cell_bloc.dart';
import 'package:studrink/blocs/game_page_view_bloc/game_page_view_bloc.dart';
import 'package:studrink/widgets/game_page_view/card_cell.dart';

class GamePageView extends StatefulWidget {
  const GamePageView();

  @override
  State<GamePageView> createState() => _GamePageViewState();
}

class _GamePageViewState extends State<GamePageView> {
  late final PageController _pageController =
      context.read<GamePageViewBloc>().state.pageController;
  int _focusedPage = 0;

  @override
  Widget build(BuildContext context) {
    final cells = context.read<CurrentGameBloc>().state.boardGame!.cells;
    return BlocListener<CurrentGameBloc, CurrentGameState>(
        listener: (context, state) {
          context
              .read<GamePageViewBloc>()
              .add(ChangePageView(state.currentPlayer!.idCurrentCell));
        },
        listenWhen: _currentPlayerChangedCell,
        child: StatefulBuilder(
          builder: (context, setState) => PageView.builder(
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
                setState(() => _focusedPage = value);
              },
              itemBuilder: (context, index) {
                final cell = cells[index], isNotFocused = _focusedPage != index;
                return AnimatedContainer(
                  padding: EdgeInsets.symmetric(
                      horizontal: isNotFocused ? 20 : 0.0,
                      vertical: isNotFocused ? 30 : 0.0),
                  duration: Duration(milliseconds: 200),
                  child: CardCell(cell: cell),
                );
              },
              itemCount: cells.length,
              controller: _pageController),
        ));
  }

  bool _currentPlayerChangedCell(
      CurrentGameState previous, CurrentGameState current) {
    return (previous.currentPlayer != current.currentPlayer) ||
        (previous.currentPlayer!.idCurrentCell !=
            current.currentPlayer!.idCurrentCell);
  }
}
