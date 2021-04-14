import 'package:flutter/material.dart';

class ColorButton extends StatelessWidget {
  const ColorButton({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    final buttonSize = 0.56 * MediaQuery.of(context).size.width;
    return Container(
      width: buttonSize,
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(34.0),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                text,
                style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.white,
                    fontSize: 26.0,
                    fontWeight: FontWeight.w600),
              ),
            )),
            onTap: () {},
          )),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34.0),
          gradient: LinearGradient(colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
    );
  }
}
