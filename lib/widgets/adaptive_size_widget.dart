import 'package:flutter/material.dart';

///
/// [Widget] to use when the parent height can be reduced and
/// you don't want render flex overflow issue. (eg : [PlwBottomNavBar] height can be reduced).
///
class AdaptiveSizeWidget extends StatelessWidget {
  const AdaptiveSizeWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [SliverFillRemaining(hasScrollBody: false, child: child)]);
  }
}
