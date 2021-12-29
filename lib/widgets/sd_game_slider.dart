import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/blocs/dice/dice_bloc.dart';
import 'package:studrink/blocs/focused_cell_bloc/focused_cell_bloc.dart';
import 'package:studrink/blocs/game_page_view_bloc/game_page_view_bloc.dart';
import 'package:studrink/blocs/nav/nav_bloc.dart';
import 'package:studrink/models/board_game.dart';
import 'package:studrink/models/cell.dart';
import 'package:studrink/models/condition_key.dart';
import 'package:studrink/models/moving.dart';
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
    const heightWidget = 200.0;
    final maxWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => CurrentGameBloc(
          navBloc: NavBloc(),
          diceBloc: DiceBloc(),
          focusedCellBloc: FocusedCellBloc())
        ..emit(CurrentGameState(
            playerList: [
              Player(
                  conditionKeyList: [ConditionKey(name: "Polypoint")],
                  state: PlayerState.ready,
                  name: "Alexis",
                  color: Colors.red,
                  idCurrentCell: 3,
                  id: 0)
            ],
            boardGame: BoardGame(
                name: "Jeux de l'oie",
                cells: [
                  Cell(
                      name: "Rentrée",
                      imgPath: "",
                      sideEffectList: ["C'est la rentrée !"]),
                  Cell(
                      cellType: CellType.selfMoving,
                      moving: Moving(count: 2, movingType: MovingType.forward),
                      name: "Polypoint",
                      imgPath: "",
                      givenConditionKey: ConditionKey(name: "Polypoint")),
                  Cell(
                      name: "4a",
                      imgPath: "",
                      cellType: CellType.conditionKey,
                      givenConditionKey: ConditionKey(name: "Polypoint"),
                      requiredConditionKey: ConditionKey(name: "Polypoint")),
                  Cell(
                      name: "Intégration BDSM",
                      imgPath: "",
                      givenConditionKey: ConditionKey(name: "BDSM")),
                  Cell(
                      name: "5A",
                      imgPath: "",
                      cellType: CellType.conditionKey,
                      sideEffectList: ["Tu bois"],
                      requiredConditionKey: ConditionKey(name: "UE"))
                ],
                imgUrl: '',
                date: DateTime.now()),
            indexCurrentPlayer: 0,
            indexNextPlayer: 0)),
      child: BlocBuilder<CurrentGameBloc, CurrentGameState>(
        builder: (context, state) {
          final playerList = state.playerListFromIdCell(
              (context.watch<GamePageViewBloc>().state.page).toInt());

          return SizedBox(
            width: maxWidth,
            height: heightWidget,
            child: Stack(
              children: [
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
                Positioned(
                    top: heightWidget / 2 - _thumbSize / 2,
                    left: _thumbPosition,
                    child: Column(
                      children: [
                        GestureDetector(
                          onPanUpdate: (details) => _updateThumbPosition(
                              maxWidth, state.boardGame!.cells.length, details),
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
                            height: 30,
                            color: Colors.white,
                          ),
                      ],
                    )),
                if (playerList.isNotEmpty)
                  Positioned(
                    left: _thumbPosition >
                            maxWidth / 2 //todo animate when mid transition
                        ? _thumbPosition -
                            (playerList.length * 40 +
                                (playerList.length - 1) * 12)
                        : _thumbPosition,
                    bottom: 0,
                    child: GlassWidget(
                        padding: EdgeInsets.all(12.0),
                        child: Wrap(
                            spacing: 12.0,
                            children: playerList
                                .map((e) => PlayerAvatar(player: e))
                                .toList())),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  void _updateThumbPosition(
      double maxWidth, int cellCount, DragUpdateDetails details) {
    setState(() => _thumbPosition = max(
        0,
        min(maxWidth - _thumbSize,
            details.globalPosition.dx - _thumbSize / 2)));
    final cellIndex = (_thumbPosition / maxWidth * cellCount).round();
    print("Cell index $cellIndex");
    context
        .read<GamePageViewBloc>()
        .add(ChangePageView(cellIndex, duration: Duration(milliseconds: 200)));
  }
}
