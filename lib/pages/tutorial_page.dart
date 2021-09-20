import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/blocs/nav/nav_bloc.dart';
import 'package:studrink/navigators/widgets/back_btn_wrapper.dart';
import 'package:studrink/pages/game_page.dart';
import 'package:studrink/pages/my_custom_page.dart';
import 'package:studrink/storage/local_storage.dart';
import 'package:studrink/utils/studrink_utils.dart';
import 'package:studrink/widgets/cell_announcer.dart';
import 'package:studrink/widgets/game_page_view/game_page_view.dart';
import 'package:studrink/widgets/player_announcer.dart';
import 'package:studrink/widgets/player_area/play_area.dart';
import 'package:studrink/widgets/sd_dialog.dart';
import 'package:studrink/widgets/selected_player_card.dart';
import 'package:studrink/widgets/turn_indicator.dart';

class TutorialPage extends MyCustomPage {
  const TutorialPage()
      : super(
            child: const TutorialScreen(),
            key: const ValueKey<String>("/tutorial"));
}

class TutorialScreen extends StatefulWidget {
  const TutorialScreen();

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen>
    with TickerProviderStateMixin, BackBtnWrapper {
  late final _topController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 750));
  late final _gameViewController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 750));
  late final _playAreaController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 750));

  OverlayEntry? _overlayEntry;
  bool _isOverlayVisible = false;

  @override
  void initState() {
    super.initState();
    _topController.forward().then((value) => _displayOverlay(context,
        content:
            "Le haut de l'écran t'indique le nom de la case courante ainsi que le nom du joueur qui doit jouer.",
        onPressed: () => _topController.reverse().then((_) =>
            _gameViewController.forward().then((value) => _displayOverlay(
                  context,
                  alignment: Alignment.topCenter,
                  content: "Le milieu de l'écran révèle les cases du jeu. " +
                      "Elles t'indiquent l'effet sur le joueur et les joueurs actuellement dessus. " +
                      "La partie plus basse te donne des informations sur le joueur sélectionné.",
                  onPressed: () => _gameViewController.reverse().then((value) =>
                      _playAreaController.forward().then((value) =>
                          _displayOverlay(
                            context,
                            content:
                                "Tout en bas, tu retrouves les contrôles du jeu. Tu pourras passer les tours, choisir les adversaires, réussir ou rater les défis ...\nLe bouton de droite te permet de connaître le classement de la partie.",
                            onPressed: () {
                              _playAreaController.reverse().then((value) =>
                                  _displayOverlay(context,
                                      title: "But du jeu",
                                      content: context
                                          .read<CurrentGameBloc>()
                                          .state
                                          .boardGame!
                                          .goal, onPressed: () {
                                    LocalStorage().write(
                                        LocalStorageKeywords.tutorialDone, "T");
                                    context.read<NavBloc>().add(ReplaceNav(
                                        pageBuilder: (_) => const GamePage()));
                                  }));
                            },
                          ))),
                )))));
  }

  void _displayOverlay(BuildContext context,
      {required String content,
      required VoidCallback onPressed,
      Alignment alignment = Alignment.center,
      String? title}) {
    final topPadding = MediaQuery.of(context).viewPadding.top;
    OverlayState overlayState = Overlay.of(context)!;
    _overlayEntry = OverlayEntry(
        builder: (context) => Positioned.fill(
            top: max(topPadding - 10, 0),
            child: Align(
              alignment: alignment,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: isTablet(context) ? 500 : null,
                  child: SdDialog(
                    title: title,
                    content: content,
                    actions: [
                      TextButton(
                          onPressed: () {
                            if (_isOverlayVisible) _overlayEntry?.remove();
                            _isOverlayVisible = false;
                            onPressed();
                          },
                          child: Text("COMPRIS",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold)))
                    ],
                  ),
                ),
              ),
            )));
    overlayState.insert(_overlayEntry!);
    _isOverlayVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
            onPressed: () {
              context.read<NavBloc>().add(const PopNav());
              if (_isOverlayVisible) _overlayEntry?.remove();
            },
            color: Colors.black),
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeTransition(
            opacity: _topController,
            child: SlideTransition(
              position: _topController
                  .drive(Tween(begin: Offset(0.0, -0.5), end: Offset.zero)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: IgnorePointer(child: const CellAnnouncer())),
                  Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: const PlayerAnnouncer()),
                ],
              ),
            ),
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Center(
                      child: FadeTransition(
                          child: IgnorePointer(child: const GamePageView()),
                          opacity: _gameViewController)))),
          Padding(
              padding: EdgeInsets.only(
                  bottom: size.height < 700 ? 25 : 50,
                  top: 20,
                  right: isTablet(context)
                      ? MediaQuery.of(context).size.width / 3
                      : 50.0,
                  left: isTablet(context)
                      ? MediaQuery.of(context).size.width / 3
                      : 50.0),
              child: FadeTransition(
                  child: const SelectedPlayerCard(),
                  opacity: _gameViewController)),
          ScaleTransition(
              child: IgnorePointer(child: const PlayArea()),
              scale: _playAreaController)
        ],
      )),
    );
  }
}
