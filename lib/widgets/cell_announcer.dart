import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/game_page_view_bloc/game_page_view_bloc.dart';
import 'package:ptit_godet/models/cell.dart';

class CellAnnouncer extends StatefulWidget {
  const CellAnnouncer();

  @override
  _CellAnnouncerState createState() => _CellAnnouncerState();
}

class _CellAnnouncerState extends State<CellAnnouncer> {
  late final List<Cell> _cells =
      context.read<CurrentGameBloc>().state.boardGame!.cells;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    final pageController =
        context.read<GamePageViewBloc>().state.pageController;
    pageController.addListener(() {
      setState(() {
        _page = pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cellName = _cells[_page].name;
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        switchInCurve: Interval(0.5, 1.0),
        switchOutCurve: Interval(0.0, 0.5),
        transitionBuilder: (child, animation) {
          return ClipRRect(
              child: FadeTransition(opacity: animation, child: child));
        },
        child: Align(
            key: ValueKey(cellName),
            alignment: Alignment.centerLeft,
            child:
                Text(cellName, style: Theme.of(context).textTheme.headline1)));
  }
}
