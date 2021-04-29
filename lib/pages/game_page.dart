import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/models/moving.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/pages/game_page_provider.dart';
import 'package:ptit_godet/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:ptit_godet/widgets/bottom_sheet/chose_opponent_list_view.dart';
import 'package:ptit_godet/widgets/cell_announcer.dart';
import 'package:ptit_godet/widgets/dice_view.dart';
import 'package:ptit_godet/widgets/game_page_view/game_page_view.dart';
import 'package:ptit_godet/widgets/player_announcer.dart';
import 'package:ptit_godet/widgets/player_area/play_area.dart';
import 'package:ptit_godet/widgets/player_overlay.dart';
import 'package:ptit_godet/widgets/selected_player_card.dart';

class GamePage extends CupertinoPage {
  const GamePage()
      : super(
            child: const GamePageProvider(child: const GameScreen()),
            key: const ValueKey<String>("/game"));
}

class GameScreen extends StatefulWidget {
  const GameScreen();

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
            onPressed: () => context.read<NavBloc>().add(const PopNav()),
            color: Colors.black),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BlocListener<CurrentGameBloc, CurrentGameState>(
              listenWhen: (previous, current) =>
                  previous.currentPlayer?.state != current.currentPlayer?.state,
              listener: _displayBottomSheet,
              child: BlocListener<CurrentGameBloc, CurrentGameState>(
                listenWhen: (previous, current) =>
                    previous.currentPlayer?.name !=
                        current.currentPlayer?.name &&
                    current.currentPlayer != null,
                listener: (context, state) =>
                    _displayOverlay(context, state, size.width, size.height),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: const CellAnnouncer(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: const PlayerAnnouncer(),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Center(child: const GamePageView())),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: size.height < 700 ? 25 : 50,
                            top: 20,
                            right: 50,
                            left: 50),
                        child: const SelectedPlayerCard()),
                    const PlayArea()
                  ],
                ),
              ),
            ),
            const DiceView()
          ],
        ),
      ),
    );
  }

  void _displayOverlay(BuildContext context, CurrentGameState state,
      double maxWidth, double maxHeight) async {
    OverlayState overlayState = Overlay.of(context)!;
    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            child: PlayerOverlayAnimated(player: state.currentPlayer!),
            width: maxWidth,
            height: maxHeight));
    overlayState.insert(overlayEntry);
    await Future.delayed(Duration(milliseconds: 2000));
    overlayEntry.remove();
  }

  void _displayBottomSheet(BuildContext context, CurrentGameState state) {
    final currentPlayerState = state.currentPlayer!.state;
    Widget content = const SizedBox();
    switch (currentPlayerState) {
      case PlayerState.choseOpponent:
        {
          content = ChoseOpponentListView(
              callback: (player) =>
                  context.read<CurrentGameBloc>().add(PickOpponent(player)),
              playerList: state.playerList
                  .where((element) => state.currentPlayer != element)
                  .toList());
          break;
        }
      case PlayerState.chosePlayerMoving:
        {
          final cells = state.boardGame!.cells,
              moving = state.currentCell!.moving!,
              movingCount = moving.movingType == MovingType.forward
                  ? moving.count
                  : -moving.count,
              playerList = state.playerListAbleToMove();

          if (playerList.isNotEmpty)
            content = ChoseOpponentListView(
                contentCallback: (player) => Text(
                    "Effets : ${cells[player.idCurrentCell + movingCount].effectsLabel}",
                    style: Theme.of(context).textTheme.bodyText1),
                playerList: playerList,
                callback: (player) => context
                    .read<CurrentGameBloc>()
                    .add(MakePlayerMoving(player)));
          break;
        }
      case PlayerState.stealConditionKey:
        {
          final playerHavingConditionKey = state.playerListAbleToBeStolen();
          if (playerHavingConditionKey.isNotEmpty)
            content = ChoseOpponentListView(
                playerList: playerHavingConditionKey,
                callback: (player) => context
                    .read<CurrentGameBloc>()
                    .add(StealConditionKey(player)));
          break;
        }
      default:
        {
          content = const SizedBox();
          break;
        }
    }
    if (!(content is SizedBox))
      showModalBottomSheet(
          isDismissible: false,
          barrierColor: Colors.black.withOpacity(0.2),
          context: context,
          builder: (context) => AppBottomSheet(child: content));
  }
}
