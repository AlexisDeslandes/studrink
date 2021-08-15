import 'package:flutter/material.dart';
import 'package:studrink/constants/button_constants.dart';

class ColorButton extends StatelessWidget {
  const ColorButton(
      {Key? key, required this.text, required this.callback, this.mini = false})
      : super(key: key);
  final String text;
  final VoidCallback callback;
  final bool mini;

  @override
  Widget build(BuildContext context) {
    final buttonSize =
        (mini ? ButtonConstants.miniButtonSize : ButtonConstants.buttonSize) *
            MediaQuery.of(context).size.width;
    return Container(
      width: buttonSize,
      height: mini ? 40.0 : 61.0,
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(ButtonConstants.buttonRadius),
            child: Center(
                child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: (mini
                      ? ButtonConstants.miniVerticalPadding
                      : ButtonConstants.verticalPadding)),
              child: Text(
                text,
                style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.white,
                    fontSize: (mini
                        ? ButtonConstants.miniFontSize
                        : ButtonConstants.fontSize),
                    fontWeight: ButtonConstants.weight),
              ),
            )),
            onTap: callback,
          )),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ButtonConstants.buttonRadius),
          boxShadow: kElevationToShadow[4],
          gradient: LinearGradient(colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
    );
  }
}
