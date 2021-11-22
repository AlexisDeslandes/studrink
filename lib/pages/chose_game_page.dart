import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/board_game/board_game_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/blocs/nav/nav_bloc.dart';
import 'package:studrink/pages/game_detail_page.dart';
import 'package:studrink/pages/market_page.dart';
import 'package:studrink/pages/my_custom_page.dart';
import 'package:studrink/utils/studrink_utils.dart';
import 'package:studrink/widgets/base_screen.dart';
import 'package:studrink/widgets/buttons/color_button.dart';
import 'package:studrink/widgets/buttons/sd_fab.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';
import 'package:studrink/widgets/pre_game/board_game_tile.dart';

class ChoseGamePage extends MyCustomPage {
  const ChoseGamePage()
      : super(
            key: const ValueKey<String>("/chose_game"),
            child: const ChoseGameScreen());
}

class ChoseGameScreen extends StatefulWidget {
  const ChoseGameScreen();

  @override
  State<StatefulWidget> createState() {
    return ChoseGameScreenState();
  }
}

class ChoseGameScreenState extends BaseScreenState {
  @override
  String get subTitle => "Choisir une partie";

  @override
  String get title => "Jouer";

  @override
  Widget? floatingActionButton(BuildContext context) => ScaleTransition(
        scale: controller.drive(CurveTween(curve: Interval(0.8, 1.0))),
        child: SDFab(
            icon: Icons.add,
            heroTag: "chose_game_fab",
            onPressed: () => controller.reverse().then((value) => context
                .read<NavBloc>()
                .add(PushNav(
                    pageBuilder: (_) => const MarketPage(),
                    onPop: () => controller.forward())))),
      );

  @override
  Widget body(BuildContext context) {
    return FadeTransition(
      opacity: controller.drive(CurveTween(curve: Interval(0.5, 1.0))),
      child:
          BlocBuilder<BoardGameBloc, BoardGameState>(builder: (context, state) {
        final boardGameList = state.boardGameList;
        if (boardGameList.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
              child: SizedBox(
                width: isTablet(context) ? 400 : null,
                child: ListView.builder(
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 4, bottom: 4),
                    child: BoardGameTile(
                        boardGame: boardGameList[index],
                        onTap: () {
                          final boardGame = boardGameList[index];
                          boardGame.screenshots.forEach((element) =>
                              precacheImage(
                                  AssetImage("assets/screenshots/$element"),
                                  context));
                          context.read<CurrentGameBloc>()
                            ..add(InitModelCurrentGame(boardGame: boardGame));
                          controller.reverse().then((value) => context
                              .read<NavBloc>()
                              .add(PushNav(
                                  pageBuilder: (_) => const GameDetailPage(),
                                  onPop: () => controller.forward())));
                        }),
                  ),
                  itemCount: boardGameList.length,
                ),
              ),
            ),
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Center(
                  child: GlassWidget(
                    padding: EdgeInsets.all(12.0),
                    child: Text("Aucun plateau de jeu n'a été installé.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 18)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: ColorButton(
                      text: "Market",
                      callback: () => controller.reverse().then((value) =>
                          context.read<NavBloc>().add(PushNav(
                              pageBuilder: (_) => MarketPage(),
                              onPop: () => controller.forward())))),
                ),
              )
            ],
          );
        }
      }),
    );
  }
}
