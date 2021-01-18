import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/widgets/back_element_screen.dart';
import 'package:ptit_godet/widgets/base_building.dart';
import 'package:ptit_godet/widgets/simple_title_screen.dart';

class DetailMarketPage extends CupertinoPage {
  const DetailMarketPage()
      : super(
            key: const ValueKey("/detail_market_page"),
            child: const DetailMarketScreen());
}

class DetailMarketScreen extends BackElementScreen
    with BaseBuilding, SimpleTitleScreen {
  const DetailMarketScreen();

  @override
  String backButtonText() {
    return "Market place";
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }

  @override
  String titleContent() {
    return "Détail";
  }
}
