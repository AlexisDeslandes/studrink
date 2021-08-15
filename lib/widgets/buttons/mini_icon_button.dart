import 'package:flutter/material.dart';

class MiniIconButton extends StatelessWidget {
  const MiniIconButton({Key? key, required this.callback, required this.icon})
      : super(key: key);

  final VoidCallback callback;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: InkWell(
          splashColor: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(100.0),
          child: Icon(icon),
          onTap: callback),
    );
  }
}
