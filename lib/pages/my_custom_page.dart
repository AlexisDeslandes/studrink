import 'package:flutter/widgets.dart';

abstract class MyCustomPage extends Page {
  final Widget child;

  const MyCustomPage({required LocalKey key, required this.child})
      : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 5),
        reverseTransitionDuration: Duration(milliseconds: 5),
        settings: this,
        pageBuilder: (context, animation, secondaryAnimation) => child);
  }
}
