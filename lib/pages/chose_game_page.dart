import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/board_game/board_game_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/pages/game_detail_page.dart';
import 'package:ptit_godet/pages/market_page.dart';
import 'package:ptit_godet/pages/my_custom_page.dart';
import 'package:ptit_godet/widgets/base_screen.dart';
import 'package:ptit_godet/widgets/buttons/color_button.dart';
import 'package:ptit_godet/widgets/glass/glass_widget.dart';
import 'package:ptit_godet/widgets/pre_game/board_game_tile.dart';

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
  Widget body(BuildContext context) {
    return BlocBuilder<BoardGameBloc, BoardGameState>(
        builder: (context, state) {
      final boardGameList = state.boardGameList;
      if (boardGameList.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: ListView.builder(
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 4, bottom: 4),
              child: BoardGameTile(
                  boardGame: boardGameList[index],
                  onTap: () {
                    context.read<CurrentGameBloc>()
                      ..add(InitModelCurrentGame(
                          boardGame: boardGameList[index]));
                    context.read<NavBloc>().add(
                        PushNav(pageBuilder: (_) => const GameDetailPage()));
                  }),
            ),
            itemCount: boardGameList.length,
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
                    callback: () => context
                        .read<NavBloc>()
                        .add(PushNav(pageBuilder: (_) => MarketPage()))),
              ),
            )
          ],
        );
      }
    });
  }
}
