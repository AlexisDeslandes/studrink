import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/focused_cell_bloc/focused_cell_bloc.dart';

class GamePageViewBloc extends Bloc<GamePageViewEvent, GamePageViewState> {
  final CurrentGameBloc currentGameBloc;
  final FocusedCellBloc focusedCellBloc;

  GamePageViewBloc(
      {@required PageController pageController,
      @required this.currentGameBloc,
      @required this.focusedCellBloc})
      : assert(pageController != null &&
            currentGameBloc != null &&
            focusedCellBloc != null),
        super(GamePageViewState(pageController)) {
    focusedCellBloc.add(ChangeFocusedCell(
        playerList: currentGameBloc.state.playerListFromCurrentCell,
        cell: currentGameBloc.state.currentCell));
  }

  @override
  Stream<GamePageViewState> mapEventToState(GamePageViewEvent event) async* {
    if (event is ChangePageView) {
      final page = event.page;
      state.pageController.animateToPage(page,
          curve: Curves.easeInOut, duration: Duration(seconds: 1));
      focusedCellBloc.add(ChangeFocusedCell(
          cell: currentGameBloc.state.currentCell,
          playerList: currentGameBloc.state.playerListFromCell(page)));
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
