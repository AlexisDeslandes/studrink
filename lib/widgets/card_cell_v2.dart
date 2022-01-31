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
    return GlassWidget(
        padding: const EdgeInsets.all(paddingValue),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(cell.name,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 30)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: paddingValue),
                child: Align(
                    child: SvgPicture.asset(_icon, width: size, height: size),
                    alignment: Alignment.center),
              ),
              Flexible(
                child: Center(
                    child: Text(
                  cell.effectsLabel,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                )),
              )
            ]));
  }
}
