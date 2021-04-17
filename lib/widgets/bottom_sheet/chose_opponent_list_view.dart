import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/widgets/player_avatar.dart';

class ChoseOpponentListView extends StatelessWidget {
  const ChoseOpponentListView(
      {required this.controller,
      required this.playerList,
      required this.callback});

  final List<Player> playerList;
  final ScrollController controller;
  final ValueChanged<Player> callback;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context, index) {
          final player = playerList[index];
          return ListTile(
              title: Text(player.name),
              leading: PlayerAvatar(player: player),
              onTap: () => callback(player));
        },
        controller: controller,
        itemCount: playerList.length);
  }
}
