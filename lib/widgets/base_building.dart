import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/widgets/background.dart';

import 'base_screen.dart';

mixin BaseBuildingState on BaseScreenState {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Background(child: LayoutBuilder(
      builder: (ctx, constraints) {
        const top = 30.0, height = 50.0, total = top + height;
        final maxHeight = constraints.maxHeight;
        return Stack(
          children: [
            backElement(context),
            Positioned(
                top: top, left: top, height: height, child: title(context)),
            Positioned(
                top: total,
                height: maxHeight - total - (hasBackElement() ? 66 : 0),
                width: size.width,
                child: body(context)),
          ],
        );
      },
    ));
  }
}
//
