import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({Key? key, required this.getChild}) : super(key: key);

  final Widget Function(ScrollController controller) getChild;

  @override
  Widget build(BuildContext context) {
    const radius = 30.0;
    return BottomSheet(
      onClosing: () {},
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radius))),
      builder: (context) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Colors.white,
            )),
        child: DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 0.5,
            expand: false,
            builder: (BuildContext context, controller) =>
                getChild(controller)),
      ),
    );
  }
}
