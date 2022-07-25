import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/models/cell.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';

class CardCellV3 extends StatefulWidget {
  const CardCellV3(
      {Key? key,
      required this.cell,
      required this.initWidth,
      required this.initHeight})
      : super(key: key);

  final Cell cell;
  final double initWidth;
  final double initHeight;

  @override
  State<CardCellV3> createState() => _CardCellV3State();
}

class _CardCellV3State extends State<CardCellV3>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 400))
        ..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initWidth = widget.initWidth;
    final initHeight = widget.initHeight;
    final cell = widget.cell;
    return AnimatedBuilder(
      animation: _controller.drive(CurveTween(curve: Curves.ease)),
      builder: (context, child) => SizedBox(
        width: (1 + _controller.value) * initWidth,
        height: (1 + _controller.value) * initHeight,
        child: child,
      ),
      child: GlassWidget(
        borderColor: context.read<CurrentGameBloc>().state.currentPlayer!.color,
        borderWidth: 3,
        padding: EdgeInsets.all(6),
        child: Column(
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
            Flexible(
                child: Text(
              cell.effectsLabel,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 14),
            )),
          ],
        ),
      ),
    );
  }
}
