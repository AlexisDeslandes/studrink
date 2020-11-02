import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const BottomButton({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(text,
          style: Theme.of(context).textTheme.button.copyWith(fontSize: 20)),
      onPressed: onPressed,
    );
  }
}
