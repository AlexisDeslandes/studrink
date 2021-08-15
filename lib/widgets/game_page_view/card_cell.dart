import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studrink/models/cell.dart';
import 'package:studrink/widgets/game_page_view/card_cell_player_list.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';

class CardCell extends StatelessWidget {
  final Cell cell;

  const CardCell({Key? key, required this.cell}) : super(key: key);

  String get _icon => "assets/icons/${cell.cellType.value}.svg";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.6;
    return GlassWidget(
        child: Stack(
      children: [
        Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Align(
                    child: SvgPicture.asset(_icon, width: size, height: size),
                    alignment: Alignment.center),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
                child: Center(
                    child: Text(
                  cell.effectsLabel,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                )),
              )
            ]),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(child: CardCellPlayerList(cell), height: 50),
        ),
      ],
    ));
  }
}
