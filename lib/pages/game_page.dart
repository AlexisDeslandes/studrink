import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/widgets/background.dart';
import 'package:ptit_godet/widgets/custom_back_button.dart';
import 'package:ptit_godet/widgets/game_page_view.dart';
import 'package:ptit_godet/widgets/player_area/play_area.dart';
import 'package:ptit_godet/widgets/player_announcer.dart';

class GamePage extends CupertinoPage {
  GamePage() : super(child: GameScreen(), key: const ValueKey<String>("/game"));
}

class GameScreen extends StatelessWidget {
  final PageController _pageController;

  GameScreen() : _pageController = PageController();

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
            const Positioned(
                child: const PlayerAnnouncer(),
                top: top,
                left: top,
                height: height),
            Positioned(
                child: GamePageView(_pageController),
                width: maxWidth,
                height: pageViewHeight,
                top: top + height),
            Positioned(
                child: PlayArea(_pageController),
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
