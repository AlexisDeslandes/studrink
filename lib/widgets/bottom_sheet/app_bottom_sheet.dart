import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const radius = 30.0;
    return Container(
      height: 222, //144 avec padding(selecterplayercard) + 78 + safearea
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                topRight: Radius.circular(radius)),
            border: Border.all(
              color: Colors.white,
            )),
        child: child);
  }
}
