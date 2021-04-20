import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ptit_godet/models/player.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar(
      {Key? key, required this.player, this.decoration, this.size = 40.0})
      : super(key: key);
  final Player player;
  final Decoration? decoration;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        decoration: decoration,
        child: ClipOval(
            child: player.avatar != null
                ? Image.memory(player.avatar!, width: size)
                : Container(color: player.color, width: size, height: size)),
      ),
    );
  }
}
