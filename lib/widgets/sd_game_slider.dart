import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/blocs/game_page_view_bloc/game_page_view_bloc.dart';
import 'package:studrink/models/player.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';
import 'package:studrink/widgets/player_avatar.dart';

class SDGameSlider extends StatefulWidget {
  const SDGameSlider({Key? key}) : super(key: key);

  @override
  _SDGameSliderState createState() => _SDGameSliderState();
}

class _SDGameSliderState extends State<SDGameSlider> {
  static const double _thumbSize = 30.0;

  double _thumbPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    const heightWidget = 320.0;
    final maxWidth = MediaQuery.of(context).size.width,
        state = context.read<CurrentGameBloc>().state,
        cells = state.boardGame!.cells,
        cellIndex =
            ((_thumbPosition - _thumbSize) / maxWidth * cells.length).round(),
        playerList = state.playerListFromIdCell(cellIndex);
    return SizedBox(
      width: maxWidth,
      height: heightWidget,
      child: Stack(
        children: [
          ..._buildPlayers(state.playerList, cellIndex, maxWidth, cells.length),
          Positioned.fill(
              child: Center(
            child: Container(
                height: 10.0,
                width: MediaQuery.of(context).size.width,
                child: GlassWidget(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: _thumbPosition + _thumbSize / 2,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(100.0)),
                      ),
                    ),
                    opacity: 0.50)),
          )),
          if (playerList.isNotEmpty)
            Positioned(
              left: _thumbPosition >
                      maxWidth / 2 //todo animate when mid transition
                  ? _thumbPosition -
                      (playerList.length * 40 + (playerList.length - 1) * 12)
                  : _thumbPosition,
              bottom: 0,
              child: GlassWidget(
                  opacity: 0.5,
                  padding: EdgeInsets.all(12.0),
                  child: Wrap(
                      spacing: 12.0,
                      children: playerList
                          .map((e) => PlayerAvatar(player: e))
                          .toList())),
            ),
          Positioned(
              top: heightWidget / 2 - _thumbSize / 2,
              left: _thumbPosition,
              child: Column(
                children: [
                  GestureDetector(
                    onPanUpdate: (details) =>
                        _updateThumbPosition(maxWidth, cells.length, details),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Theme.of(context).primaryColor
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)),
                          width: _thumbSize,
                          height: _thumbSize),
                    ),
                  ),
                  if (playerList.isNotEmpty)
                    Container(
                      width: 2,
                      height: 23,
                      color: Colors.white,
                    ),
                ],
              ))
        ],
      ),
    );
  }

  void _updateThumbPosition(
      double maxWidth, int cellCount, DragUpdateDetails details) {
    setState(() => _thumbPosition = max(
        0,
        min(maxWidth - _thumbSize,
            details.globalPosition.dx - _thumbSize / 2)));
    final cellIndex =
        ((_thumbPosition - _thumbSize) / maxWidth * cellCount).round();
    print("Cell index $cellIndex");
    context
        .read<GamePageViewBloc>()
        .add(ChangePageView(cellIndex, duration: Duration(milliseconds: 200)));
  }

  List<Widget> _buildPlayers(
      List<Player> playerList, int cellIndex, double maxWidth, int cellCount) {
    final playerListSortedByIdCurrentCell = playerList
            .where((element) => element.idCurrentCell != cellIndex)
            .toList()
          ..sort((a, b) => a.idCurrentCell.compareTo(b.idCurrentCell)),
        widgets = <Widget>[];
    var shiftCount = 0;

    for (var i = 0; i < playerListSortedByIdCurrentCell.length; i++) {
      final player = playerListSortedByIdCurrentCell[i];
      final isPreceded = i > 0 &&
          player.idCurrentCell - 1 ==
              playerListSortedByIdCurrentCell[i - 1].idCurrentCell;
      if (isPreceded) shiftCount = (shiftCount + 1) % 3;
      final shiftValue = shiftCount * 45.0;
      widgets.add(Positioned.fill(
          child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PlayerAvatar(player: player),
                  Container(
                      color: Colors.white, height: 30.0 + shiftValue, width: 3)
                ],
              )),
          left: player.idCurrentCell * (maxWidth / cellCount) - 20,
          bottom: 60.0 + shiftValue));
    }

    return widgets.reversed.toList();
  }
}
