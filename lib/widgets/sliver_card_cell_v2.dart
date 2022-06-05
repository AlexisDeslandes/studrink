import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/models/cell.dart';
import 'package:studrink/widgets/card_cell_v2.dart';

class SliverCardCellV2 extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return BlocSelector<CurrentGameBloc, CurrentGameState, Cell>(
        selector: (state) => state.currentCell!,
        builder: (context, cell) => Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 20, bottom: 12),
              child: CardCellV2(cell: cell),
            ));
  }

  @override
  double get maxExtent => 320;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
