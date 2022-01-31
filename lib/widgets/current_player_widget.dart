import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:studrink/extension/color_extension.dart';
import 'package:studrink/models/player.dart';
import 'package:studrink/widgets/player_avatar.dart';

class CurrentPlayerWidget extends StatelessWidget {
  const CurrentPlayerWidget({Key? key, required this.player}) : super(key: key);

  final Player player;

  @override
  Widget build(BuildContext context) {
    const glowSize = 70.0;
    final playerColor = player.color,
        shouldTextColorBeWhite = playerColor.shouldTextColorBeWhite;
    return AvatarGlow(
        glowColor: playerColor,
        child: Stack(
          children: [
            PlayerAvatar(
              player: player,
              size: 60,
            ),
            Positioned.fill(
                child: Center(
                    child: Text(player.shortName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: shouldTextColorBeWhite
                                ? Colors.white
                                : Colors.black))))
          ],
        ),
        endRadius: glowSize);
  }
}
