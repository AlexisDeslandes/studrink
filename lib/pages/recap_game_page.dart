import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/game_page_view_bloc/game_page_view_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/models/condition_key.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/pages/my_custom_page.dart';
import 'package:ptit_godet/widgets/base_screen.dart';
import 'package:ptit_godet/widgets/glass/glass_widget.dart';
import 'package:collection/collection.dart';
import 'package:ptit_godet/widgets/recap_player_list_tile.dart';

class RecapGamePage extends MyCustomPage {
  const RecapGamePage()
      : super(key: const ValueKey("/recap"), child: const RecapGameScreen());
}

class RecapGameScreen extends StatefulWidget {
  const RecapGameScreen({Key? key}) : super(key: key);

  @override
  _RecapGameScreenState createState() => _RecapGameScreenState();
}

class _RecapGameScreenState extends BaseScreenState {
  @override
  Widget body(BuildContext context) {
    final gameState = context.read<CurrentGameBloc>().state,
        playerList = gameState.playerListInWinOrder;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            final player = playerList[index];
            return RecapGameCard(
              player: player,
              index: index,
              onSearch: () {
                context
                    .read<GamePageViewBloc>()
                    .add(ChangePageView(player.idCurrentCell));
                controller.reverse().then(
                    (value) => context.read<NavBloc>().add(const PopNav()));
              },
            );
          },
          itemCount: playerList.length),
    );
  }

  @override
  String get subTitle => "Classements des joueurs";

  @override
  String get title => "Résumé";
}

class RecapGameCard extends StatelessWidget {
  const RecapGameCard(
      {Key? key,
      required this.player,
      required this.index,
      required this.onSearch})
      : super(key: key);

  final int index;
  final Player player;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final conditionKeyList = player.conditionKeyList;
    final Map<ConditionKey, int> conditionKeyMap = conditionKeyList
        .fold<Map<ConditionKey, int>>({}, (previousValue, element) {
      if (previousValue.containsKey(element))
        return previousValue..[element] = previousValue[element]! + 1;
      return previousValue..[element] = 1;
    });

    return GlassWidget(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Column(children: [
          RecapPlayerListTile(player: player, index: index),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children: conditionKeyMap.entries.mapIndexed((index, entry) {
                    final conditionKey = entry.key, value = entry.value;
                    return Chip(
                        label: Text("$value ${conditionKey.name}(s)"),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: index % 2 == 0
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).accentColor);
                  }).toList()),
            ),
          ),
          Row(
            children: [
              Expanded(child: const SizedBox()), //todo add drinks
              IconButton(onPressed: onSearch, icon: Icon(Icons.search))
            ],
          )
        ]));
  }
}
