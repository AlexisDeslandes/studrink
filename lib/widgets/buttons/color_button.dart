import 'package:flutter/material.dart';
import 'package:ptit_godet/constants/button_constants.dart';

class ColorButton extends StatelessWidget {
  const ColorButton({Key? key, required this.text, required this.callback})
      : super(key: key);
  final String text;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    final buttonSize =
        ButtonConstants.buttonSize * MediaQuery.of(context).size.width;
    return Container(
      width: buttonSize,
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(ButtonConstants.buttonRadius),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: ButtonConstants.verticalPadding),
              child: Text(
                text,
                style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.white,
                    fontSize: ButtonConstants.fontSize,
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
