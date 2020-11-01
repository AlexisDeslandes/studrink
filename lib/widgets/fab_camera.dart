import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/models/player.dart';

class FabCamera extends StatelessWidget {
  final Player player;

  const FabCamera({Key key, @required this.player})
      : assert(player != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _takePicture,
      mini: true,
      child: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
    );
  }

  void _takePicture() {}
}
