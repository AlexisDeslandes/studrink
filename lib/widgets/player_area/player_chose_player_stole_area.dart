import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/widgets/bottom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class PlayerChosePlayerStoleArea extends StatefulWidget {
  final List<Player> playerHavingConditionKey;
  final PageController pagePageViewController;

  PlayerChosePlayerStoleArea(
      this.playerHavingConditionKey, this.pagePageViewController);

  @override
  _PlayerChosePlayerStoleAreaState createState() =>
      _PlayerChosePlayerStoleAreaState();
}

class _PlayerChosePlayerStoleAreaState
    extends State<PlayerChosePlayerStoleArea> {
  PageController _playerChosePageController;

  @override
  void initState() {
    final playerList = widget.playerHavingConditionKey,
        idInitialPlayer = playerList.length > 1 ? 1 : 0;
    _playerChosePageController =
        PageController(viewportFraction: 0.3, initialPage: idInitialPlayer);
    super.initState();
  }

  void _animateToPageGameView(int page) {
    widget.pagePageViewController.animateToPage(page,
        duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }

  void _onPageChanged(int value) {
    final idCellFocusedPlayer = widget.playerHavingConditionKey[value].idCurrentCell;
    _animateToPageGameView(idCellFocusedPlayer);
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
                  controller: _playerChosePageController,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    final player = widget.playerHavingConditionKey[index];
                    return Center(
                      child: BottomButton(
                        text: player.name,
                        onPressed: () {
                          context
                              .bloc<CurrentGameBloc>()
                              .add(StealConditionKey(player));
                        },
                      ),
                    );
                  },
                  itemCount: widget.playerHavingConditionKey.length),
            ))
      ],
    );
  }
}
