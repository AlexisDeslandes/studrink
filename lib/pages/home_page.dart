import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:studrink/blocs/board_game/board_game_bloc.dart';
import 'package:studrink/blocs/nav/nav_bloc.dart';
import 'package:studrink/constants/sd_constants.dart';
import 'package:studrink/navigators/widgets/back_btn_wrapper.dart';
import 'package:studrink/pages/chose_game_page.dart';
import 'package:studrink/pages/create_game_page.dart';
import 'package:studrink/pages/my_custom_page.dart';
import 'package:studrink/utils/studrink_utils.dart';
import 'package:studrink/widgets/buttons/color_button.dart';
import 'package:studrink/widgets/buttons/white_button.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';

class HomePage extends MyCustomPage {
  const HomePage()
      : super(child: const HomeScreen(), key: const ValueKey<String>("/home"));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, BackBtnWrapper {
  late final _controller =
      AnimationController(vsync: this, duration: SDConstants.pageAnimDuration)
        ..forward();

  void _navToPlayGame() {
    final boardGameList = context.read<BoardGameBloc>().state.boardGameList;
    boardGameList.where((element) => element.imgUrl.startsWith("http")).forEach(
        (element) => DefaultCacheManager().downloadFile(element.imgUrl));
    _controller.reverse().then((_) => context.read<NavBloc>().add(PushNav(
        pageBuilder: (_) => const ChoseGamePage(),
        onPop: () => _controller.forward())));
  }

  void _navToCreateGame() {
    _controller.reverse().then((_) => context.read<NavBloc>().add(PushNav(
        pageBuilder: (_) => const CreateGamePage(),
        onPop: () => _controller.forward())));
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size,
        isATablet = isTablet(context),
        size =
            isTablet(context) ? mediaSize.width * 0.4 : mediaSize.width * 0.663;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: SlideTransition(
                position: _controller
                    .drive(CurveTween(curve: Curves.easeInOut))
                    .drive(Tween(begin: Offset(0.0, -0.35), end: Offset.zero)),
                child: FadeTransition(
                    opacity: _controller,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: GlassWidget(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: isATablet ? 20 : 0),
                            width: size,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: Text("Studrink",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2),
                                  ),
                                  ColorButton(
                                      text: "Jouer", callback: _navToPlayGame),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: WhiteButton(
                                          text: "Créer",
                                          callback: _navToCreateGame))
                                ])))))));
  }
}
