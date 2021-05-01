import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptit_godet/blocs/board_game/board_game_bloc.dart';
import 'package:ptit_godet/blocs/market_place/market_place_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/widgets/buttons/color_button.dart';
import 'package:ptit_godet/widgets/buttons/white_button.dart';
import 'package:ptit_godet/widgets/detail_market/screenshot_view.dart';
import 'package:ptit_godet/widgets/glass/glass_text.dart';

class DetailMarketPage extends CupertinoPage {
  const DetailMarketPage()
      : super(
            key: const ValueKey("/detail_market_page"),
            child: const DetailMarketScreen());
}

class DetailMarketScreen extends StatefulWidget {
  const DetailMarketScreen();

  @override
  State<StatefulWidget> createState() => DetailMarketScreenState();
}

class DetailMarketScreenState extends State<DetailMarketScreen> {
  @override
  Widget build(BuildContext context) {
    final boardGame = context.read<MarketPlaceBloc>().state.chosenBoardGame!;
    final isImgFromWeb = boardGame.imgUrl.startsWith("http");
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(
              onPressed: () => context.read<NavBloc>().add(const PopNav()),
              color: Colors.black)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                      height: 70.0,
                      width: 70.0,
                      child: isImgFromWeb
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(boardGame.imgUrl))
                          : Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, left: 5.0),
                              child: SvgPicture.asset(boardGame.imgUrl),
                            )),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(boardGame.name,
                          style: Theme.of(context).textTheme.headline2),
                    ),
                  ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BlocBuilder<BoardGameBloc, BoardGameState>(
                      builder: (context, state) {
                        final boardGameList = state.boardGameList;
                        if (boardGameList.contains(boardGame))
                          return ColorButton(
                            text: "Désinstaller",
                            callback: () {
                              context
                                  .read<BoardGameBloc>()
                                  .add(DeleteBoardGame(boardGame));
                            },
                            mini: true,
                          );
                        return ColorButton(
                          text: "Installer",
                          callback: () {
                            context
                                .read<BoardGameBloc>()
                                .add(AddBoardGame(boardGame));
                          },
                          mini: true,
                        );
                      },
                    ),
                    WhiteButton(
                      text: "S'abonner",
                      callback: () {},
                      mini: true,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: GlassText(text: boardGame.description),
              ),
              Expanded(
                child: ScreenshotView(screenshots: boardGame.screenshots),
              )
            ],
          ),
        ),
      ),
    );
  }
}
