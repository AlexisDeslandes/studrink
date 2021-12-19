import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/blocs/nav/nav_bloc.dart';
import 'package:studrink/models/board_game.dart';
import 'package:studrink/pages/chose_players_page.dart';
import 'package:studrink/pages/my_custom_page.dart';
import 'package:studrink/widgets/base_screen.dart';
import 'package:studrink/widgets/buttons/color_button.dart';
import 'package:studrink/widgets/detail_market/screenshot_view.dart';
import 'package:studrink/widgets/glass/glass_text.dart';

class GameDetailPage extends MyCustomPage {
  const GameDetailPage()
      : super(
            key: const ValueKey("/game_detail"),
            child: const GameDetailScreen());
}

class GameDetailScreen extends StatefulWidget {
  const GameDetailScreen();

  @override
  _GameDetailScreenState createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends BaseScreenState {
  late final BoardGame _boardGame =
      context.read<CurrentGameBloc>().state.boardGame!;

  @override
  String get subTitle => _boardGame.teaser;

  @override
  String get title => _boardGame.name;

  @override
  Duration get duration => Duration(milliseconds: 1000);

  @override
  Widget body(BuildContext context) {
    final boardGame = context.read<CurrentGameBloc>().state.boardGame!;
    return Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30.0),
        child: Column(children: [
          SlideTransition(
            position: controller
                .drive(CurveTween(
                    curve: Interval(0.5, 0.8, curve: Curves.easeInOut)))
                .drive(Tween(begin: Offset(0.0, -0.1), end: Offset.zero)),
            child: FadeTransition(
                child: GlassText(text: boardGame.description),
                opacity:
                    controller.drive(CurveTween(curve: Interval(0.5, 1.0)))),
          ),
          Expanded(
            child: FadeTransition(
                child: ScreenshotView(
                  cells: boardGame.cells,
                  pickImage: (builder, args) => controller.reverse().then(
                      (value) => context.read<NavBloc>().add(PushNav(
                          pageBuilder: builder,
                          args: args,
                          onPop: () => controller.forward()))),
                ),
                opacity:
                    controller.drive(CurveTween(curve: Interval(0.5, 1.0)))),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: ScaleTransition(
                  scale: controller
                      .drive(CurveTween(
                          curve: Interval(
                        0.8,
                        1.0,
                      )))
                      .drive(TweenSequence([
                        TweenSequenceItem(
                            tween: Tween(begin: 0.0, end: 1.3), weight: 0.7),
                        TweenSequenceItem(
                            tween: Tween(begin: 1.3, end: 1.0), weight: 0.3)
                      ])),
                  child: ColorButton(
                      text: "Lancer",
                      callback: () => controller.reverse().then((value) =>
                          context.read<NavBloc>().add(PushNav(
                              pageBuilder: (_) => const ChosePlayersPage(),
                              onPop: () => controller.forward()))))))
        ]));
  }
}
