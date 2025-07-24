import 'package:flutter/material.dart';
import 'package:studrink/models/player.dart';
import 'package:studrink/widgets/player_avatar.dart';

class RecapPlayerListTile extends StatelessWidget {
  const RecapPlayerListTile(
      {Key? key, required this.player, required this.index})
      : super(key: key);

  final Player player;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: PlayerAvatar(player: player),
      title: Text(
        player.name,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontSize: 24, fontWeight: FontWeight.w400),
      ),
      subtitle: Text(
        "Case n°${player.idCurrentCell + 1}",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      trailing: Text("${index + 1}${index == 0 ? "er" : "è"}",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 24)),
    );
  }
}
