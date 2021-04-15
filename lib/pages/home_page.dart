import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/pages/chose_game_page.dart';
import 'package:ptit_godet/pages/market_page.dart';
import 'package:ptit_godet/widgets/buttons/color_button.dart';
import 'package:ptit_godet/widgets/buttons/white_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/widgets/glass/glass_widget.dart';

class HomePage extends CupertinoPage {
  const HomePage()
      : super(child: const HomeScreen(), key: const ValueKey<String>("/home"));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.663;
    return Center(
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
                      callback: () => context.read<NavBloc>().add(PushNav(
                            pageBuilder: (_) => const ChoseGamePage(),
                          ))),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: WhiteButton(
                      text: "Market",
                      callback: () => context
                          .read<NavBloc>()
                          .add(PushNav(pageBuilder: (_) => const MarketPage())),
                    ),
                  )
                ],
              ))),
    );
  }
}
