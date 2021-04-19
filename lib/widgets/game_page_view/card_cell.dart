import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ptit_godet/models/cell.dart';
import 'package:ptit_godet/widgets/game_page_view/card_cell_player_list.dart';
import 'package:ptit_godet/widgets/glass/glass_widget.dart';

class CardCell extends StatelessWidget {
  final Cell cell;

  const CardCell({Key? key, required this.cell}) : super(key: key);

  IconData get _icon {
    switch (cell.cellType) {
      case CellType.noEffect:
        return MdiIcons.glassMugVariant;
      case CellType.conditionKey:
        return Icons.assistant_photo;
      case CellType.selfMoving:
        return Icons.double_arrow;
      case CellType.otherMoving:
        return Icons.subdirectory_arrow_right;
      case CellType.turnLose:
        return Icons.stop;
      case CellType.prison:
        return Icons.vpn_key;
      case CellType.selfThrowDice:
        return Icons.threesixty_rounded;
      case CellType.selfChallenge:
        return MdiIcons.trophy;
      case CellType.selfMovingPlayerChose:
        return Icons.compare_arrows;
      case CellType.battle:
        return MdiIcons.fencing;
      case CellType.steal:
        return Icons.work_off;
      case CellType.ifElse:
        return MdiIcons.accountMultipleCheck;
      case CellType.finish:
        return Icons.check;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassWidget(
        child: Stack(
      children: [
        Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Align(
                    child: Icon(_icon,
                        size: MediaQuery.of(context).size.width * 0.4),
                    alignment: Alignment.center),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
