import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/focused_cell_bloc/focused_cell_bloc.dart';

class GamePageViewBloc extends Bloc<GamePageViewEvent, GamePageViewState> {
  final CurrentGameBloc currentGameBloc;
  final FocusedCellBloc focusedCellBloc;

  GamePageViewBloc(
      {required PageController pageController,
      required this.currentGameBloc,
      required this.focusedCellBloc})
      : super(GamePageViewState(pageController)) {
    final playerListOnCurrentCell =
        currentGameBloc.state.playerListFromCurrentCell;
    if (playerListOnCurrentCell.isNotEmpty) {
      focusedCellBloc.add(ChangeFocusedPlayer(playerListOnCurrentCell[0]));
    }
  }

  @override
  Stream<GamePageViewState> mapEventToState(GamePageViewEvent event) async* {
    if (event is ChangePageView) {
      final page = event.page;
      state.pageController.animateToPage(page,
          curve: Curves.easeInOut, duration: Duration(seconds: 1));
      final currentGameBlocState = currentGameBloc.state,
          playerListOnCell = currentGameBlocState.playerListFromIdCell(page),
          currentPlayer = currentGameBlocState.currentPlayer;
      if (playerListOnCell.contains(currentPlayer)) {
        focusedCellBloc.add(ChangeFocusedPlayer(currentPlayer!));
      } else if (playerListOnCell.isNotEmpty) {
        focusedCellBloc.add(ChangeFocusedPlayer(playerListOnCell[0]));
      }
    }
  }
}

class GamePageViewState extends Equatable {
  final PageController pageController;

  const GamePageViewState(this.pageController);

  @override
  List<Object> get props => [pageController];
}

abstract class GamePageViewEvent extends Equatable {
  const GamePageViewEvent();

  @override
  List<Object> get props => [];
}

class ChangePageView extends GamePageViewEvent {
  final int page;

  const ChangePageView(this.page);
}
