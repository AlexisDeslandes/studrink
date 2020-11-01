import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/widgets/back_element_screen.dart';

class GamePage extends CupertinoPage {
  const GamePage()
      : super(child: const GameScreen(), key: const ValueKey<String>("/game"));
}

class GameScreen extends BackElementScreen {
  const GameScreen();

  @override
  Widget body(BuildContext context) {
    return Container();
  }

  @override
  String title() {

    return "Jeu";
  }

  @override
  String backButtonText() {
    return "";
  }
}
