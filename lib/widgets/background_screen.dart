import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base_screen.dart';

mixin BackgroundScreen on BaseScreen {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).primaryColor
            ])),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              const top = 30.0, height = 50.0, total = top + height;
              final maxHeight = constraints.maxHeight;
              return Stack(
                children: [
                  backElement(context),
                  Positioned(
                      top: top,
                      left: top,
                      height: height,
                      child: Text(title(),
                          style: Theme.of(context).textTheme.headline1)),
                  Positioned(
                      top: total,
                      height: maxHeight - total - (hasBackElement() ? 66 : 0),
                      width: size.width,
                      child: body(context)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
//
