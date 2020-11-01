import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/widgets/background_screen.dart';
import 'package:ptit_godet/widgets/base_screen.dart';

abstract class NoBackElementScreen extends BaseScreen with BackgroundScreen {
  const NoBackElementScreen();


  @override
  bool hasBackElement() => false;

  @override
  Widget backElement(BuildContext context) {
    return Container();
  }
}
