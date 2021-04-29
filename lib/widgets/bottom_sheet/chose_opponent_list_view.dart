import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/widgets/player_avatar.dart';

typedef ChoseOpponentContentCallback = Widget Function(Player player);

class ChoseOpponentListView extends StatelessWidget {
  const ChoseOpponentListView(
      {required this.playerList, required this.callback, this.contentCallback});

  final List<Player> playerList;
  final ValueChanged<Player> callback;
  final ChoseOpponentContentCallback? contentCallback;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context, index) {
          final player = playerList[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                  trailing: Icon(Icons.chevron_right),
                  title: Text(
                    player.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 24, fontWeight: FontWeight.w400),
                  ),
                  leading: PlayerAvatar(player: player),
                  subtitle: Text(
                    "Case ${player.idCurrentCell + 1}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    callback(player);
                  }),
              if (contentCallback != null)
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: contentCallback!(player))
            ],
          );
        },
        shrinkWrap: true,
        itemCount: playerList.length);
  }
}
