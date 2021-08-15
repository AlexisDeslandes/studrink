import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/game_page_view_bloc/game_page_view_bloc.dart';
import 'package:ptit_godet/models/condition_key.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/widgets/buttons/mini_icon_button.dart';
import 'package:ptit_godet/widgets/glass/glass_widget.dart';
import 'package:ptit_godet/widgets/recap_player_list_tile.dart';

class RecapGameScrollView extends StatefulWidget {
  const RecapGameScrollView({Key? key, this.controller}) : super(key: key);

  final ScrollController? controller;

  @override
  _RecapGameScrollViewState createState() => _RecapGameScrollViewState();
}

class _RecapGameScrollViewState extends State<RecapGameScrollView> {
  @override
  Widget build(BuildContext context) {
    final gameState = context.read<CurrentGameBloc>().state,
        playerList = gameState.playerListInWinOrder;
    return CustomScrollView(
      controller: widget.controller,
      slivers: [
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 16, bottom: 10),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Résumé",
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 30)),
                Text("Classements des joueurs",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontSize: 13)),
              ]),
        )),
        SliverList(
            delegate: SliverChildListDelegate(playerList
                .mapIndexed((index, e) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7.5, horizontal: 10),
                      child: RecapGameCard(
                        player: e,
                        index: index,
                        onSearch: () => context
                            .read<GamePageViewBloc>()
                            .add(ChangePageView(e.idCurrentCell)),
                      ),
                    ))
                .toList())),
      ],
    );
  }
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
    const bullet = "\u2022";
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 10),
                child: Text(
                    player.drinkMap.entries
                        .where((element) => element.value > 0)
                        .fold(
                            "",
                            (previousValue, element) =>
                                previousValue +
                                "${previousValue.isNotEmpty ? "\n" : ""}$bullet ${element.value} ${element.key.label}"),
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 15),
                    softWrap: true),
              )),
              Material(
                  child: MiniIconButton(callback: onSearch, icon: Icons.search))
            ],
          )
        ]));
  }
}
