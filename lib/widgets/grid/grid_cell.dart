import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studrink/models/cell.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';

class GridCell extends StatelessWidget {
  const GridCell({Key? key, required this.cellIndex, required this.cell})
      : super(key: key);

  //Starting at 0
  final int cellIndex;
  final Cell cell;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: GlassWidget(
            padding: EdgeInsets.all(12),
            child: Center(
              child: SvgPicture.asset(
                cell.iconPath,
              ),
            ),
          ),
        ),
        if (!(((cellIndex + 3) % 6 == 0) || ((cellIndex + 4) % 6 == 0)))
          Positioned.fill(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    color: Colors.black,
                    width: 4,
                    height: 3,
                  ))),
        if (!(((cellIndex) % 6 == 0) || ((cellIndex + 1) % 6 == 0)))
          Positioned.fill(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    color: Colors.black,
                    width: 4,
                    height: 3,
                  ))),
        if ((cellIndex + 1) % 3 == 0)
          Positioned.fill(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black,
                    width: 4,
                    height: 3,
                  ))),
        if ((cellIndex) % 3 == 0 && cellIndex != 0)
          Positioned.fill(
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: Colors.black,
                    width: 4,
                    height: 3,
                  )))
      ],
    );
  }
}
