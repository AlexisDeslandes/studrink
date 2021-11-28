import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studrink/blocs/board_game/board_game_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/blocs/market_place/market_place_bloc.dart';
import 'package:studrink/blocs/nav/nav_bloc.dart';
import 'package:studrink/navigators/widgets/back_btn_wrapper.dart';
import 'package:studrink/pages/chose_players_page.dart';
import 'package:studrink/pages/game_detail_page.dart';
import 'package:studrink/pages/my_custom_page.dart';
import 'package:studrink/utils/studrink_utils.dart';
import 'package:studrink/widgets/buttons/color_button.dart';
import 'package:studrink/widgets/buttons/white_button.dart';
import 'package:studrink/widgets/detail_market/screenshot_view.dart';
import 'package:studrink/widgets/glass/glass_text.dart';

class DetailMarketPage extends MyCustomPage {
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

class DetailMarketScreenState extends State<DetailMarketScreen>
    with TickerProviderStateMixin, BackBtnWrapper {
  late final _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 900))
        ..forward();

  @override
  Widget build(BuildContext context) {
    final boardGame = context.read<MarketPlaceBloc>().state.chosenBoardGame!,
        isImgFromWeb = boardGame.imgUrl.startsWith("http"),
        isATablet = isTablet(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: FadeTransition(
            opacity: _controller,
            child: BackButton(
                onPressed: () => _controller.reverse().then(
                    (value) => context.read<NavBloc>().add(const PopNav())),
                color: Colors.black),
          )),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: SlideTransition(
                  position: _controller
                      .drive(CurveTween(curve: Interval(0.0, 1 / 3)))
                      .drive(Tween(begin: Offset(0.0, -0.3), end: Offset.zero)),
                  child: FadeTransition(
                    opacity: _controller
                        .drive(CurveTween(curve: Interval(0.0, 1 / 3))),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.start,
                      spacing: 10.0,
                      children: [
                        if (!kIsWeb || isTablet(context))
                          SizedBox(
                              height: 50.0,
                              width: 50.0,
                              child: isImgFromWeb
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.network(boardGame.imgUrl))
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, left: 5.0),
                                      child: SvgPicture.asset(boardGame.imgUrl),
                                    )),
                        Text(boardGame.name,
                            style: Theme.of(context).textTheme.headline2)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isATablet ? 75 : 0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ScaleTransition(
                        scale: _controller
                            .drive(CurveTween(curve: Interval(2 / 3, 1.0)))
                            .drive(TweenSequence([
                              TweenSequenceItem(
                                  tween: Tween(begin: 0.0, end: 1.3),
                                  weight: 0.7),
                              TweenSequenceItem(
                                  tween: Tween(begin: 1.3, end: 1.0),
                                  weight: 0.3)
                            ])),
                        child: BlocBuilder<BoardGameBloc, BoardGameState>(
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
                      ),
                      ScaleTransition(
                        scale: _controller
                            .drive(CurveTween(curve: Interval(2 / 3, 1.0)))
                            .drive(TweenSequence([
                              TweenSequenceItem(
                                  tween: Tween(begin: 0.0, end: 1.3),
                                  weight: 0.7),
                              TweenSequenceItem(
                                  tween: Tween(begin: 1.3, end: 1.0),
                                  weight: 0.3)
                            ])),
                        child: BlocBuilder<BoardGameBloc, BoardGameState>(
                          builder: (context, state) => WhiteButton(
                            text: "Lancer",
                            callback: state.boardGameList.contains(boardGame)
                                ? () {
                                    boardGame.screenshots.forEach((element) =>
                                        precacheImage(
                                            AssetImage(
                                                "assets/screenshots/$element"),
                                            context));
                                    context.read<CurrentGameBloc>()
                                      ..add(InitModelCurrentGame(
                                          boardGame: boardGame));
                                    _controller.reverse().then((value) =>
                                        context.read<NavBloc>().add(PushNav(
                                            pageBuilder: (_) =>
                                                const ChosePlayersPage(),
                                            onPop: () =>
                                                _controller.forward())));
                                  }
                                : null,
                            mini: true,
                          ),
                        ),
                      )
                    ]
                        .map((e) => Flexible(
                            child: Padding(
                                padding: isATablet
                                    ? EdgeInsets.symmetric(horizontal: 20.0)
                                    : EdgeInsets.zero,
                                child: e)))
                        .toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: isATablet ? 75 : 8.0),
                  child: FadeTransition(
                      opacity: _controller
                          .drive(CurveTween(curve: Interval(1 / 3, 2 / 3))),
                      child: GlassText(text: boardGame.description)),
                ),
              ),
              Expanded(
                child: FadeTransition(
                  opacity: _controller
                      .drive(CurveTween(curve: Interval(1 / 3, 2 / 3))),
                  child: ScreenshotView(
                    screenshots: boardGame.screenshots,
                    pickImage: (builder, args) => _controller.reverse().then(
                        (value) => context.read<NavBloc>().add(PushNav(
                            pageBuilder: builder,
                            args: args,
                            onPop: () => _controller.forward()))),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
