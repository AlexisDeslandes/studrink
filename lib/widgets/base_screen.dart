import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';

abstract class BaseScreenState<W extends StatefulWidget> extends State<W>
    with TickerProviderStateMixin {
  late final AnimationController controller =
      AnimationController(vsync: this, duration: duration)..forward();

  Duration get duration => Duration(milliseconds: 600);

  String get title;

  String get subTitle;

  Widget backButton(BuildContext context) => FadeTransition(
        opacity: controller,
        child: BackButton(
            onPressed: () => controller
                .reverse()
                .then((value) => context.read<NavBloc>().add(const PopNav())),
            color: Colors.black),
      );

  Widget body(BuildContext context);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: floatingActionButton(context),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: backButton(context),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SlideTransition(
                position: controller
                    .drive(CurveTween(
                        curve: Interval(0.0, 0.5, curve: Curves.easeInOut)))
                    .drive(Tween(begin: Offset(0.0, -0.5), end: Offset.zero)),
                child: FadeTransition(
                  opacity: controller,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0),
                          child: Text(title,
                              style: Theme.of(context).textTheme.headline1),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0),
                          child: Text(subTitle,
                              style: Theme.of(context).textTheme.subtitle1),
                        ),
                      ]),
                ),
              ),
              Expanded(child: body(context))
            ],
          ),
        ),
      );

  Widget? floatingActionButton(BuildContext context) => null;
}
