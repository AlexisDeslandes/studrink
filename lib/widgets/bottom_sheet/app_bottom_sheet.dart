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
      enableDrag: false,
      builder: (context) => Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
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

/*
DraggableScrollableSheet(
          initialChildSize: 0.2,
          minChildSize: 0.2,
          maxChildSize: 0.5,
          expand: false,
          builder: (BuildContext context, controller) => ListView.builder(
                controller: controller,
                itemBuilder: (context, index) => ListTile(
                  title: Text("lol $index"),
                ),
                itemCount: 20,
              ))
 */
