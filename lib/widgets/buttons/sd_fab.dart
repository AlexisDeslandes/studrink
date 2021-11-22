import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SDFab extends StatelessWidget {
  const SDFab({Key? key, required this.icon, this.onPressed, this.heroTag})
      : super(key: key);

  final IconData icon;
  final VoidCallback? onPressed;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        heroTag: heroTag,
        child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                gradient: LinearGradient(colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColor
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Icon(icon, color: Colors.white)),
        onPressed: onPressed);
  }
}
