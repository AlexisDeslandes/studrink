import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/pages/game_page_provider.dart';
import 'package:ptit_godet/widgets/base_screen.dart';
import 'package:ptit_godet/widgets/cell_announcer.dart';
import 'package:ptit_godet/widgets/custom_back_button.dart';
import 'package:ptit_godet/widgets/dice_view.dart';
import 'package:ptit_godet/widgets/game_page_view/game_page_view.dart';
import 'package:ptit_godet/widgets/player_announcer.dart';
import 'package:ptit_godet/widgets/player_area/play_area.dart';
import 'package:ptit_godet/widgets/player_overlay.dart';

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
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
            onPressed: () => context.read<NavBloc>().add(const PopNav()),
            color: Colors.black),
      ),
      body: Column(
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
          Expanded(child: const PlayArea())
        ],
      ),
    ));
  }

  /*
  Stack(children: [
            Positioned(
                child: const PlayerAnnouncer(),
                width: MediaQuery.of(context).size.width - offset,
                top: offset,
                left: offset,
                height: offset),
            Positioned(
                child: const GamePageView(),
                width: maxWidth,
                height: pageViewHeight,
                top: 2 * offset),
            Positioned(
                child: const PlayArea(),
                top: pageViewHeight + 2 * offset,
                height: maxHeight - (pageViewHeight + 2 * offset)),
            const Positioned(
                child: const CustomBackButton(), bottom: 0, left: 10),
            Positioned(
                child: const DiceView(), width: maxWidth, height: maxHeight)
            //Positioned(child: const PlayerOverlay(), width: maxWidth, height: maxHeight)
          ])
   */

  void _displayOverlay(BuildContext context, CurrentGameState state,
      double maxWidth, double maxHeight) async {
    OverlayState overlayState = Overlay.of(context)!;
    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            child: PlayerOverlay(
                name: state.currentPlayer!.name,
                color: state.currentPlayer!.color,
                picture: state.currentPlayer!.avatar!),
            width: maxWidth,
            height: maxHeight));
    overlayState.insert(overlayEntry);
    await Future.delayed(Duration(milliseconds: 1300));
    overlayEntry.remove();
  }
}
