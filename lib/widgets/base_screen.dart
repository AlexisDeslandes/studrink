import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';

abstract class BaseScreenState<W extends StatefulWidget> extends State<W> {
  String get title;

  String get subTitle;

  Widget backButton(BuildContext context) => BackButton(
      onPressed: () => context.read<NavBloc>().add(const PopNav()),
      color: Colors.black);

  Widget body(BuildContext context);

  @override
  Widget build(BuildContext context) => SafeArea(
          child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: backButton(context),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child: Text(title, style: Theme.of(context).textTheme.headline1),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child:
                  Text(subTitle, style: Theme.of(context).textTheme.subtitle1),
            ),
            Expanded(child: body(context))
          ],
        ),
      ));
}
