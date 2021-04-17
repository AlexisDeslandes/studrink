import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/game_page_view_bloc/game_page_view_bloc.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/widgets/bottom_button.dart';

class PlayerChosePlayerMovingArea extends StatefulWidget {
  final List<Player> playerList;

  const PlayerChosePlayerMovingArea(this.playerList);

  @override
  _PlayerChosePlayerMovingAreaState createState() =>
      _PlayerChosePlayerMovingAreaState();
}

class _PlayerChosePlayerMovingAreaState
    extends State<PlayerChosePlayerMovingArea> {
  @override
  void initState() {
    final playerList = widget.playerList,
        idInitialPlayer = playerList.length > 1 ? 1 : 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    /*
    return Column(
      children: [
        Text(
            "Fait glisser horizontalement les propositions ci-dessous pour choisir.",
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center),
        Expanded(
            child: Container(
          color: Color.fromRGBO(0, 0, 0, 0.1),
          child: PageView.builder(
              controller: _playerChosePageController,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final player = widget.playerList[index];
                return Center(
                  child: BottomButton(
                    text: player.name,
                    onPressed: () {
                      context
                          .read<CurrentGameBloc>()
                          .add(MakePlayerMoving(player));
                    },
                  ),
                );
              },
              itemCount: widget.playerList.length),
        ))
      ],
    );

     */
  }

  void _onPageChanged(int value) {
    final idCellFocusedPlayer = widget.playerList[value].idCurrentCell;
    context.read<GamePageViewBloc>().add(ChangePageView(idCellFocusedPlayer));
  }
}
