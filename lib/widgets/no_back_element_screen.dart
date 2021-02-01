import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/widgets/base_building.dart';
import 'package:ptit_godet/widgets/base_screen.dart';
import 'package:ptit_godet/widgets/simple_title_screen.dart';

abstract class NoBackElementScreen extends BaseScreenState
    with BaseBuildingState, SimpleTitleScreen {
  @override
  bool hasBackElement() => false;

  @override
  Widget backElement(BuildContext context) {
    return Container();
  }
}
