import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const BottomButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(text,
          style: Theme.of(context).textTheme.button?.copyWith(fontSize: 20)),
      onPressed: onPressed,
    );
  }
}
