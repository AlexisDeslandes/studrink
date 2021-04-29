import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const radius = 30.0;
    final heightSafeAreaBottom = MediaQuery.of(context).padding.bottom,
        maxHeight = heightSafeAreaBottom +
            212; //222 (size of screen from bottom that we can hide) - 10 (padding)
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius)),
              border: Border.all(
                color: Colors.white,
              )),
          child: child),
    );
  }
}
