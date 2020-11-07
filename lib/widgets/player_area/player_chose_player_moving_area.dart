import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/widgets/bottom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerChosePlayerMovingArea extends StatefulWidget {
  final List<Player> playerList;
  final PageController gamePageViewController;

  PlayerChosePlayerMovingArea(this.playerList, this.gamePageViewController);

  @override
  _PlayerChosePlayerMovingAreaState createState() =>
      _PlayerChosePlayerMovingAreaState();
}

class _PlayerChosePlayerMovingAreaState
    extends State<PlayerChosePlayerMovingArea> {
  PageController playerChosePageController;

  @override
  void initState() {
    final playerList = widget.playerList,
        idInitialPlayer = playerList.length > 1 ? 1 : 0;
    playerChosePageController =
        PageController(viewportFraction: 0.3, initialPage: idInitialPlayer);
    super.initState();
  }

  void _animateToPageGameView(int page) {
    widget.gamePageViewController.animateToPage(page,
        duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
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
              controller: playerChosePageController,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final player = widget.playerList[index];
                return Center(
                  child: BottomButton(
                    text: player.name,
                    onPressed: () {
                      context
                          .bloc<CurrentGameBloc>()
                          .add(MakePlayerMoving(player));
                    },
                  ),
                );
              },
              itemCount: widget.playerList.length),
        ))
      ],
    );
  }

  void _onPageChanged(int value) {
    final idCellFocusedPlayer = widget.playerList[value].idCurrentCell;
    _animateToPageGameView(idCellFocusedPlayer);
  }
}
