import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ptit_godet/blocs/board_game/board_game_bloc.dart';
import 'package:ptit_godet/blocs/market_place/market_place_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/navigators/widgets/back_btn_wrapper.dart';
import 'package:ptit_godet/pages/chose_game_page.dart';
import 'package:ptit_godet/pages/market_page.dart';
import 'package:ptit_godet/pages/my_custom_page.dart';
import 'package:ptit_godet/widgets/buttons/color_button.dart';
import 'package:ptit_godet/widgets/buttons/white_button.dart';
import 'package:ptit_godet/widgets/glass/glass_widget.dart';

class HomePage extends MyCustomPage {
  const HomePage()
      : super(child: const HomeScreen(), key: const ValueKey<String>("/home"));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin, BackBtnWrapper {
  late final _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500))
        ..forward();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.663;
    return Center(
      child: SlideTransition(
        position: _controller
            .drive(CurveTween(curve: Curves.easeInOut))
            .drive(Tween(begin: Offset(0.0, -0.35), end: Offset.zero)),
        child: FadeTransition(
          opacity: _controller,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: GlassWidget(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  width: size,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text("Petit Godet",
                            style: Theme.of(context).textTheme.headline2),
                      ),
                      ColorButton(
                          text: "Jouer",
                          callback: () {
                            final boardGameList = context
                                .read<BoardGameBloc>()
                                .state
                                .boardGameList;
                            boardGameList
                                .where((element) =>
                                    element.imgUrl.startsWith("http"))
                                .forEach((element) => DefaultCacheManager()
                                    .downloadFile(element.imgUrl));
                            _controller.reverse().then((_) => context
                                .read<NavBloc>()
                                .add(PushNav(
                                    pageBuilder: (_) => const ChoseGamePage(),
                                    onPop: () => _controller.forward())));
                          }),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: WhiteButton(
                          text: "Market",
                          callback: () {
                            final boardGameList = context
                                .read<MarketPlaceBloc>()
                                .state
                                .boardGameList;
                            boardGameList
                                .where((element) =>
                                    element.imgUrl.startsWith("http"))
                                .forEach((element) => DefaultCacheManager()
                                    .downloadFile(element.imgUrl));
                            _controller.reverse().then((value) => context
                                .read<NavBloc>()
                                .add(PushNav(
                                    pageBuilder: (_) => const MarketPage(),
                                    onPop: () => _controller.forward())));
                          },
                        ),
                      )
                    ],
                  ))),
        ),
      ),
    );
  }
}
