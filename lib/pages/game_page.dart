import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/pages/game_page_provider.dart';
import 'package:ptit_godet/widgets/background.dart';
import 'package:ptit_godet/widgets/custom_back_button.dart';
import 'package:ptit_godet/widgets/game_page_view.dart';
import 'package:ptit_godet/widgets/player_announcer.dart';
import 'package:ptit_godet/widgets/player_area/play_area.dart';

class GamePage extends CupertinoPage {
  const GamePage()
      : super(
            child: const GamePageProvider(child: const GameScreen()),
            key: const ValueKey<String>("/game"));
}

class GameScreen extends StatelessWidget {
  const GameScreen();

  @override
  Widget build(BuildContext context) {
    const top = 30.0, height = 30.0;
    return Background(child: LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight,
            maxWidth = constraints.maxWidth,
            pageViewHeight = maxHeight * 0.7;
        return Stack(
          children: [
            Positioned(
                child: const PlayerAnnouncer(),
                width: MediaQuery.of(context).size.width - top,
                top: top,
                left: top,
                height: height),
            Positioned(
                child: const GamePageView(),
                width: maxWidth,
                height: pageViewHeight,
                top: top + height),
            Positioned(
                child: const PlayArea(),
                top: pageViewHeight + top + height,
                height: maxHeight - (pageViewHeight + top + height)),
            const Positioned(
                child: const CustomBackButton(), bottom: 0, left: 10)
          ],
        );
      },
    ));
  }
}
