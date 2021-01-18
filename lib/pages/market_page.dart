import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptit_godet/blocs/market_place/market_place_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/pages/detail_market_page.dart';
import 'package:ptit_godet/widgets/back_element_screen.dart';
import 'package:ptit_godet/widgets/base_building.dart';
import 'package:ptit_godet/widgets/simple_title_screen.dart';

///
/// Page that contains market place of P'tit godet.
///
class MarketPage extends CupertinoPage {
  const MarketPage()
      : super(child: const MarketScreen(), key: const ValueKey("/market"));
}

class MarketScreen extends BackElementScreen
    with BaseBuilding, SimpleTitleScreen {
  const MarketScreen();

  @override
  String backButtonText() {
    return "Accueil";
  }

  @override
  Widget body(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Material(
            elevation: 3,
            child: TextField(
              autocorrect: false,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: "Rechercher",
                  //Rechercher ou saisir un code
                  prefixIcon: Icon(Icons.search)),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
              child: Wrap(spacing: 5, runSpacing: 5, children: [
                ChoiceChip(
                    label: Text("Top des jeux"),
                    selected: true,
                    elevation: 2,
                    onSelected: (_) {}),
                ChoiceChip(label: Text("Evénements"), selected: false),
                ChoiceChip(label: Text("Nouveaux"), selected: false)
              ])),
          Expanded(
              child: BlocBuilder<MarketPlaceBloc, MarketPlaceState>(
                  builder: (context, state) => ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 20.0),
                      itemBuilder: (context, index) => MarketGameTile(
                          index: index, boardGame: state.boardGameList[index]),
                      itemCount: state.boardGameList.length)))
        ]));
  }

  @override
  String titleContent() {
    return "Market place";
  }
}

class MarketGameTile extends StatelessWidget {
  final BoardGame boardGame;
  final int index;

  const MarketGameTile(
      {Key key, @required this.boardGame, @required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImgFromWeb = boardGame.imgUrl.startsWith("http");
    return Material(
      child: InkWell(
        onTap: () => context
            .bloc<NavBloc>()
            .add(PushNav(pageBuilder: (_) => const DetailMarketPage())),
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text("${index + 1}"),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: Material(
                          borderRadius: BorderRadius.circular(6),
                          elevation: 2,
                          child: isImgFromWeb
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(boardGame.imgUrl))
                              : Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: SvgPicture.asset(boardGame.imgUrl),
                                )))),
              Expanded(
                child: Align(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Column(
                        children: [
                          Text(
                            boardGame.name,
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(fontSize: 14),
                          ),
                          Text(
                            boardGame.subTitle,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Text(
                            boardGame.tag,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(fontSize: 8.0),
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly),
                  ),
                  alignment: Alignment.topLeft,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
