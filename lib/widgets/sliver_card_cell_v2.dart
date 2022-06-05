import 'package:flutter/widgets.dart';
import 'package:studrink/widgets/game_page_view/game_page_view.dart';

class SliverGamePageView extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: const GamePageView(),
      );

  @override
  double get maxExtent => 310;

  @override
  double get minExtent => 200;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
