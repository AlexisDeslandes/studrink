import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/focused_cell_bloc/focused_cell_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/pages/game_page_provider.dart';
import 'package:ptit_godet/widgets/cell_announcer.dart';
import 'package:ptit_godet/widgets/game_bottom_sheet.dart';
import 'package:ptit_godet/widgets/game_page_view/game_page_view.dart';
import 'package:ptit_godet/widgets/glass/glass_widget.dart';
import 'package:ptit_godet/widgets/player_announcer.dart';
import 'package:ptit_godet/widgets/player_area/play_area.dart';
import 'package:ptit_godet/widgets/player_avatar.dart';
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomSheet: const GameBottomSheet(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
            onPressed: () => context.read<NavBloc>().add(const PopNav()),
            color: Colors.black),
      ),
      body: SafeArea(
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
                padding:
                    EdgeInsets.only(bottom: 50, top: 20, right: 50, left: 50),
                child: const SelectedPlayerCard()),
            const PlayArea()
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
