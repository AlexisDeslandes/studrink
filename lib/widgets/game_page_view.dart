import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/widgets/card_cell.dart';

class GamePageView extends StatefulWidget {
  final PageController pageController;

  const GamePageView(this.pageController);

  @override
  _GamePageViewState createState() => _GamePageViewState();
}

class _GamePageViewState extends State<GamePageView> {

  @override
  Widget build(BuildContext context) {
    final state = context.bloc<CurrentGameBloc>().state;
    final cells = state.boardGame.cells;
    return BlocListener<CurrentGameBloc, CurrentGameState>(
      listener: _changeCell,
      listenWhen: _currentPlayerChangedCell,
      child: PageView.builder(
          //physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final cell = cells[index];
            return CardCell(cell: cell);
          },
          itemCount: cells.length,
          controller: widget.pageController),
    );
  }

  void _changeCell(BuildContext context, CurrentGameState state) {
    widget.pageController.animateToPage(state.currentPlayer.idCurrentCell,
        duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }

  bool _currentPlayerChangedCell(
      CurrentGameState previous, CurrentGameState current) {
    return (previous.currentPlayer != current.currentPlayer) ||
        (previous.currentPlayer.idCurrentCell !=
            current.currentPlayer.idCurrentCell);
  }
}
