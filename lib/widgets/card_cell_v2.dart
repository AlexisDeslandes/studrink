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
    const paddingValue = 10.0;
    var effectsLabel = cell.effectsLabel;
    if (effectsLabel.endsWith("\n"))
      effectsLabel = effectsLabel.substring(0, effectsLabel.length - 1);
    return ClipRRect(
      child: GlassWidget(
          padding: const EdgeInsets.all(paddingValue),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(cell.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 30)),
                Expanded(child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(child: SvgPicture.asset(_icon)),
                )),
                Center(
                    child: Text(
                  effectsLabel,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ))
              ])),
    );
  }
}
