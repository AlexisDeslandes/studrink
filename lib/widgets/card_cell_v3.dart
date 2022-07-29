import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/models/cell.dart';
import 'package:studrink/widgets/condition_widget.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';
import 'package:tuple/tuple.dart';

class JeSaisPas extends StatefulWidget {
  const JeSaisPas({Key? key, this.cellTuple}) : super(key: key);

  final Tuple2<Cell, Rect>? cellTuple;

  @override
  State<JeSaisPas> createState() => _JeSaisPasState();
}

class _JeSaisPasState extends State<JeSaisPas>
    with SingleTickerProviderStateMixin {
  late Tuple2<Cell, Rect>? _focusCellTuple = widget.cellTuple;

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
    return ConditionWidget(
        appear: _focusCellTuple != null,
        appearWidgetCallback: () {
          final rect = _focusCellTuple!.item2;
          final cell = _focusCellTuple!.item1;
          return Positioned(
              top: rect.top,
              left: rect.left,
              child: CardCellV3(
                key: ObjectKey(cell),
                controller: _controller,
                cell: cell,
                initWidth: rect.width,
                initHeight: rect.height,
                onReduce: () => setState(() => _focusCellTuple = null),
              ));
        });
  }
}

class CardCellV3 extends StatelessWidget {
  const CardCellV3(
      {Key? key,
      required this.cell,
      required this.initWidth,
      required this.initHeight,
      required this.onReduce,
      required this.controller})
      : super(key: key);

  final Cell cell;
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
                      style: Theme.of(context).textTheme.headline2,
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
                        .bodyText1
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
          ],
        ),
      ),
    );
  }
}
