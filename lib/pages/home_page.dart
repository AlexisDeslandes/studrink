import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/pages/chose_game_page.dart';
import 'package:ptit_godet/pages/create_home_page.dart';
import 'package:ptit_godet/pages/market_page.dart';
import 'package:ptit_godet/widgets/no_back_element_screen.dart';

class HomePage extends CupertinoPage {
  const HomePage()
      : super(child: const HomeScreen(), key: const ValueKey<String>("/home"));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends NoBackElementScreen {
  @override
  Widget body(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
              child: Center(
            child: SvgPicture.asset(
              "assets/icons/beer.svg",
              width: MediaQuery.of(context).size.width / 3,
            ),
          )),
          Flexible(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Center(
                    child: RaisedButton(
                  child: Text("Jouer"),
                  onPressed: () => context.bloc<NavBloc>().add(PushNav(
                        pageBuilder: (dynamic) => const ChoseGamePage(),
                      )),
                )),
              ),
              Flexible(
                  child: RaisedButton(
                child: Text("Catalogue"),
                onPressed: () => context
                    .bloc<NavBloc>()
                    .add(PushNav(pageBuilder: (dynamic) => const MarketPage())),
              ))
            ],
          ))
        ],
      ),
    );
  }

  @override
  String titleContent() {
    return "P'tit Godet";
  }
}
