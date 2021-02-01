import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/widgets/base_screen.dart';

mixin SimpleTitleScreen on BaseScreenState {

  String titleContent();

  @override
  Widget title(BuildContext context) {
    return Text(titleContent(), style: Theme.of(context).textTheme.headline1);
  }
}
