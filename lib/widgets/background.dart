import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/widgets/paints/app_background_paint.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return Scaffold(
      body: AppBackgroundPaint(
        child: SafeArea(
          child: child,
        ),
      ),
    );
  }
}
