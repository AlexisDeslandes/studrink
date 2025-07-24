import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/models/cell.dart';
import 'package:studrink/models/player.dart';
import 'package:studrink/widgets/condition_widget.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';
import 'package:studrink/widgets/player_avatar.dart';
import 'package:tuple/tuple.dart';

class JeSaisPas extends StatefulWidget {
  const JeSaisPas({Key? key, this.cellTuple}) : super(key: key);

  final Tuple2<int, Rect>? cellTuple;

  @override
  State<JeSaisPas> createState() => _JeSaisPasState();
}

class _JeSaisPasState extends State<JeSaisPas>
    with SingleTickerProviderStateMixin {
  late Tuple2<int, Rect>? _focusCellTuple = widget.cellTuple;

  late final AnimationController _controller = AnimationController(
      vsync: this, duration: Duration(milliseconds: 200), upperBound: 1.1);

  @override
  void initState() {
    super.initState();
    if (_focusCellTuple != null) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant JeSaisPas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_focusCellTuple?.item1 != widget.cellTuple?.item1) {
      if (_focusCellTuple != null) {
        _controller.reverse().then((_) {
          setState(() {
            _focusCellTuple = widget.cellTuple;
            //_controller.forward();
          });
        });
      } else {
        setState(() => _focusCellTuple = widget.cellTuple);
        _controller.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ConditionWidget(
        appear: _focusCellTuple != null,
        appearWidgetCallback: () {
          final rect = _focusCellTuple!.item2;
          var left, right;
          final indexCell = _focusCellTuple!.item1;
          if (rect.left <= width / 2) {
            left = rect.left;
          } else {
            right = width - rect.right;
          }

          return Positioned(
              top: rect.top,
              left: left,
              right: right,
              child: BlocSelector<CurrentGameBloc, CurrentGameState,
                  Tuple2<Cell, List<Player>>>(
                selector: (state) {
                  final cell = state.boardGame!.cells[indexCell];
                  final players = state.playerListFromIdCell(indexCell);
                  return Tuple2(cell, players);
                },
                builder: (context, tuple) => CardCellV3(
                  key: ObjectKey(indexCell),
                  indexCell: indexCell,
                  controller: _controller,
                  cell: tuple.item1,
                  playerList: tuple.item2,
                  initWidth: rect.width,
                  initHeight: rect.height,
                  onReduce: () => setState(() => _focusCellTuple = null),
                ),
              ));
        });
  }
}

class CardCellV3 extends StatelessWidget {
  const CardCellV3(
      {Key? key,
      required this.indexCell,
      required this.cell,
      required this.playerList,
      required this.initWidth,
      required this.initHeight,
      required this.onReduce,
      required this.controller})
      : super(key: key);

  final int indexCell;
  final Cell cell;
  final List<Player> playerList;
  final AnimationController controller;
  final double initWidth;
  final double initHeight;
  final VoidCallback onReduce;

  @override
  Widget build(BuildContext context) {
    //todo add players and cell number
    return AnimatedBuilder(
      animation: controller.drive(CurveTween(curve: Curves.ease)),
      builder: (context, child) => SizedBox(
        width: (1 + controller.value) * initWidth,
        height: (1 + controller.value) * initHeight,
        child: child,
      ),
      child: GlassWidget(
        borderColor: context.read<CurrentGameBloc>().state.currentPlayer!.color,
        borderWidth: 3,
        padding: EdgeInsets.all(6),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  width: initWidth - 18,
                  height: initHeight - 18,
                  child: SvgPicture.asset(
                    cell.iconPath,
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      cell.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                Expanded(
                    child: Center(
                  child: Text(
                    cell.effectsLabel,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 14),
                  ),
                )),
              ],
            ),
            Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                    onPressed: () =>
                        controller.reverse().then((_) => onReduce()),
                    icon: Icon(Icons.close_fullscreen))),
            Positioned.fill(
                bottom: 4,
                right: 4,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GlassWidget(
                      padding: EdgeInsets.all(3),
                      child: Text("${indexCell + 1}",
                          style: TextStyle(fontSize: 15))),
                )),
            Positioned(
                top: 10,
                left: 10,
                //todo adapt size
                child: Wrap(
                  spacing: 4,
                  children: playerList
                      .map((e) => PlayerAvatar(player: e, size: 30))
                      .toList(),
                ))
          ],
        ),
      ),
    );
  }
}
