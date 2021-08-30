import 'package:flutter/material.dart';

enum MyChoiceChipPosition { LEFT, MID, RIGHT }

class MyChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final MyChoiceChipPosition position;

  const MyChoiceChip(
      {Key? key,
      required this.label,
      required this.selected,
      required this.onSelected,
      required this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var borderRadius;
    if (position == MyChoiceChipPosition.LEFT)
      borderRadius = BorderRadius.only(
          topLeft: Radius.circular(12.0), bottomLeft: Radius.circular(12.0));
    else if (position == MyChoiceChipPosition.MID)
      borderRadius = BorderRadius.zero;
    else
      borderRadius = BorderRadius.only(
          topRight: Radius.circular(12.0), bottomRight: Radius.circular(12.0));
    return Material(
      elevation: 3,
      borderRadius: borderRadius,
      color: Colors.transparent,
      child: Container(
        width: 90,
        decoration: BoxDecoration(
            color: selected ? null : Colors.white,
            borderRadius: borderRadius,
            gradient: selected
                ? LinearGradient(colors: [
                    Theme.of(context).accentColor,
                    Theme.of(context).primaryColor
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                : null),
        child: Material(
          child: InkWell(
            borderRadius: borderRadius,
            onTap: () => onSelected(selected),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(label,
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 14.0, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
