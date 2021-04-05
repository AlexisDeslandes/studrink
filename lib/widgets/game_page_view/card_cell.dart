import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ptit_godet/models/cell.dart';
import 'package:ptit_godet/models/pastel_colors.dart';
import 'package:ptit_godet/widgets/game_page_view/card_cell_condition_key_list.dart';
import 'package:ptit_godet/widgets/game_page_view/card_cell_player_list.dart';
import 'package:ptit_godet/widgets/game_page_view/card_cell_player_selected_abel.dart';

class CardCell extends StatelessWidget {
  final Cell cell;

  const CardCell({Key? key, required this.cell})
      : assert(cell != null),
        super(key: key);

  get _cardColor => PastelColors.colors[cell.cellType.index];

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
    return MdiIcons.glassMugVariant;
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 30.0,
        verticalPadding = 15.0,
        positionedPadding = 10.0;
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
                  maxWidth = constraints.maxWidth,
                  difference = (maxHeight - maxWidth).abs();
              return Padding(
                padding: EdgeInsets.all(difference > 20 ? 0 : 20 - difference),
                child: Container(
                  width: maxWidth,
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                            height: maxHeight,
                            width: maxHeight,
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 3.0),
                                child: Card(
                                    elevation: 3,
                                    color: _cardColor,
                                    child:
                                        Center(child: Icon(_icon, size: 70))))),
                        Positioned(
                            child: CardCellPlayerList(cell),
                            top: positionedPadding,
                            left: positionedPadding,
                            width: maxWidth),
                        Positioned(
                            child: CardCellConditionKeyList(cell),
                            bottom: positionedPadding,
                            right: positionedPadding),
                        Positioned(
                            child: CardCellPlayerSelectedLabel(cell),
                            left: positionedPadding,
                            bottom: positionedPadding)
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: verticalPadding),
          child: SizedBox(
              height: 80,
              child: Center(
                  child: Text(
                cell.effectsLabel,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ))),
        )
      ],
    );
  }
}
