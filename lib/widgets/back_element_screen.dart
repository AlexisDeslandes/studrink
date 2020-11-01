import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/widgets/background_screen.dart';
import 'package:ptit_godet/widgets/base_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BackElementScreen extends BaseScreen with BackgroundScreen {
  const BackElementScreen();

  String backButtonText();

  @override
  bool hasBackElement() => true;

  @override
  Widget backElement(BuildContext context) {
    return Positioned(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left),
              iconSize: 50.0,
              onPressed: () => context.bloc<NavBloc>().add(const PopNav()),
            ),
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
