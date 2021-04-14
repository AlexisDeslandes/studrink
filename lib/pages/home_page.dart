import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/widgets/buttons/color_button.dart';
import 'package:ptit_godet/widgets/buttons/white_button.dart';
import 'package:ptit_godet/widgets/paints/app_background_paint.dart';

class HomePage extends CupertinoPage {
  const HomePage()
      : super(child: const HomeScreen(), key: const ValueKey<String>("/home"));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.663,
        buttonSize = 0.56 * MediaQuery.of(context).size.width;
    return AppBackgroundPaint(
        child: Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 12.0, sigmaX: 12.0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            width: size,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(25.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text("Petit Godet",
                      style: Theme.of(context).textTheme.headline2),
                ),
                ColorButton(text: "Jouer"),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: WhiteButton(
                    text: "Market",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
