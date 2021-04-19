import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/pages/chose_players_page.dart';
import 'package:ptit_godet/widgets/base_screen.dart';
import 'package:ptit_godet/widgets/buttons/color_button.dart';
import 'package:ptit_godet/widgets/detail_market/screenshot_view.dart';
import 'package:ptit_godet/widgets/glass/glass_text.dart';

class GameDetailPage extends CupertinoPage {
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
  String get subTitle => _boardGame.subTitle;

  @override
  String get title => _boardGame.name;

  @override
  Widget body(BuildContext context) {
    final boardGame = context.read<CurrentGameBloc>().state.boardGame!;
    return Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30.0),
        child: Column(children: [
          GlassText(text: boardGame.description),
          Expanded(
            child: ScreenshotView(screenshots: boardGame.screenshots),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: ColorButton(
                  text: "Lancer",
                  callback: () => context.read<NavBloc>().add(
                      PushNav(pageBuilder: (_) => const ChosePlayersPage()))))
        ]));
  }
}
