import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studrink/models/cell.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';

class CardCellV2 extends StatelessWidget {
  const CardCellV2({Key? key, required this.cell}) : super(key: key);

  final Cell cell;

  String get _icon => "assets/icons/${cell.cellType.value}.svg";

  @override
  Widget build(BuildContext context) {
    const paddingValue = 10.0, size = 150.0;
    var effectsLabel = cell.effectsLabel;
    if (effectsLabel.endsWith("\n"))
      effectsLabel = effectsLabel.substring(0, effectsLabel.length - 1);
    return GlassWidget(
        padding: const EdgeInsets.all(paddingValue),
        child: ListView(children: [
          Text(cell.name,
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontSize: 30)),
          Center(child: SvgPicture.asset(_icon, width: size, height: size)),
          Text(
            effectsLabel,
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          )
        ]));
  }
}
