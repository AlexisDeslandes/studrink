import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/widgets/base_building.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/widgets/base_screen.dart';
import 'package:ptit_godet/widgets/custom_back_button.dart';

abstract class BackElementScreen extends BaseScreen with BaseBuilding {
  const BackElementScreen();

  String backButtonText();

  @override
  bool hasBackElement() => true;

  @override
  Widget backElement(BuildContext context) {
    return Positioned(
        child: Row(
          children: [
            const CustomBackButton(),
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
