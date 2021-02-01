import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/widgets/base_building.dart';
import 'package:ptit_godet/widgets/base_screen.dart';
import 'package:ptit_godet/widgets/custom_back_button.dart';

abstract class BackElementScreenState extends BaseScreenState with BaseBuildingState {

  String backButtonText();

  @override
  bool hasBackElement() => true;

  Future<bool> backButtonCallback(BuildContext context) async => true;

  @override
  Widget backElement(BuildContext context) {
    return Positioned(
        child: Row(
          children: [
            CustomBackButton(callback: backButtonCallback),
            Text(
              backButtonText(),
              style: Theme.of(context).textTheme.bodyText2,
            )
          ],
        ),
        bottom: 0,
        left: 10);
  }
}
