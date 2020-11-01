import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/models/cell.dart';

class CardCell extends StatelessWidget {
  final Cell cell;

  const CardCell({Key key, @required this.cell})
      : assert(cell != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 30.0, verticalPadding = 15.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: horizontalPadding, bottom: verticalPadding),
          child: Text(cell.name, style: Theme.of(context).textTheme.headline1),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxHeight = constraints.maxHeight,
                  maxWidth = constraints.maxWidth;
              return Container(
                width: maxWidth,
                child: Center(
                  child: Container(
                      height: maxHeight, width: maxHeight, child: Card()),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: verticalPadding),
          child: Center(child: Text(cell.effectsLabel)),
        )
      ],
    );
  }
}
