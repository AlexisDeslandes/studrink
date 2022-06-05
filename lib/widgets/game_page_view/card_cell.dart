import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studrink/models/cell.dart';
import 'package:studrink/widgets/condition_widget.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';

class CardCell extends StatelessWidget {
  const CardCell({Key? key, required this.cell}) : super(key: key);

  final Cell cell;

  String get _icon => "assets/icons/${cell.cellType.value}.svg";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.6;
    return GlassWidget(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 15.0),
              child: Text(cell.name,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 30))),
          Expanded(
            child: Align(
                child: ConditionWidget(
                    appear: cell.imgPath != null,
                    appearWidgetCallback: () => Padding(
                          padding: const EdgeInsets.only(
                              top: 30.0, left: 8.0, right: 8.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: Image.asset(cell.imgPath!)),
                        ),
                    replaceWidgetCallback: () =>
                        SvgPicture.asset(_icon, width: size, height: size)),
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
        ]));
  }
}
