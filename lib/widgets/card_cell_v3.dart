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
    return AnimatedBuilder(
      animation: _controller.drive(CurveTween(curve: Curves.ease)),
      builder: (context, child) => SizedBox(
        width: widget.initWidth + _controller.value * widget.initWidth,
        height: widget.initHeight + _controller.value * widget.initHeight,
        child: child,
      ),
      child: GlassWidget(
        borderColor: context.read<CurrentGameBloc>().state.currentPlayer!.color,
        borderWidth: 3,
        padding: EdgeInsets.all(6),
        child: SvgPicture.asset(
          widget.cell.iconPath,
        ),
      ),
    );
  }
}
