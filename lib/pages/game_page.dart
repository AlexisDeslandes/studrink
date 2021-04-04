import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/pages/game_page_provider.dart';
import 'package:ptit_godet/widgets/background.dart';
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

class GameScreen extends StatelessWidget {
  const GameScreen();

  @override
  Widget build(BuildContext context) {
    const offset = 30.0;
    return Background(child: LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight,
            maxWidth = constraints.maxWidth,
            pageViewHeight = maxHeight * 0.7;
        return BlocListener<CurrentGameBloc, CurrentGameState>(
          listenWhen: (previous, current) =>
              !current.isEmpty &&
              previous.currentPlayer!.name != current.currentPlayer!.name,
          listener: (context, state) =>
              _displayOverlay(context, state, maxWidth, maxHeight),
          child: Stack(children: [
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
          ]),
        );
      },
    ));
  }

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
