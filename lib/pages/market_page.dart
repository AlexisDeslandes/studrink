import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptit_godet/blocs/board_game/board_game_bloc.dart';
import 'package:ptit_godet/blocs/market_place/market_place_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/pages/detail_market_page.dart';
import 'package:ptit_godet/widgets/glass/glass_widget.dart';
import 'package:ptit_godet/widgets/my_choice_chip.dart';

///
/// Page that contains market place of P'tit godet.
///
class MarketPage extends CupertinoPage {
  const MarketPage()
      : super(child: const MarketScreen(), key: const ValueKey("/market"));
}

class MarketScreen extends StatefulWidget {
  const MarketScreen();

  @override
  State<StatefulWidget> createState() => MarketScreenState();
}

class MarketScreenState extends State<MarketScreen> {
  late final TextEditingController _searchController = TextEditingController(
      text: context.read<MarketPlaceBloc>().state.searchWord);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: GlassWidget(
                  border: false,
                  radius: 12,
                  opacity: 0.5,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    autocorrect: false,
                    controller: _searchController,
                    onChanged: (value) => context
                        .read<MarketPlaceBloc>()
                        .add(SearchMarket(value)),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        hintText: "Rechercher",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context
                                .read<MarketPlaceBloc>()
                                .add(SearchMarket(""));
                          },
                        )),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: BlocBuilder<MarketPlaceBloc, MarketPlaceState>(
                      buildWhen: (previous, current) =>
                          previous.selectedSort != current.selectedSort,
                      builder: (context, state) => Row(
                          children: MarketSort.values
                              .map((sort) => Expanded(
                                    child: MyChoiceChip(
                                        position: sort.position,
                                        label: sort.description,
                                        selected: state.selectedSort == sort,
                                        onSelected: (_) => context
                                            .read<MarketPlaceBloc>()
                                            .add(ChangeMarketSort(sort))),
                                  ))
                              .toList()))),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: BlocBuilder<MarketPlaceBloc, MarketPlaceState>(
                    builder: (context, state) {
                  final boardGameListTreated = state.boardGameListTreated;
                  return BlocBuilder<BoardGameBloc, BoardGameState>(
                    builder: (context, boardGameState) =>
                        StaggeredGridView.countBuilder(
                            itemCount: boardGameListTreated.length,
                            crossAxisCount: 2,
                            staggeredTileBuilder: (index) =>
                                StaggeredTile.fit(1),
                            itemBuilder: (context, index) {
                              final boardGame = boardGameListTreated[index];
                              return MarketGameTile(
                                  installed: boardGameState.boardGameList
                                      .contains(boardGame),
                                  boardGame: boardGame);
                            },
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0),
                  );
                }),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class MarketGameTile extends StatelessWidget {
  const MarketGameTile(
      {Key? key, required this.boardGame, required this.installed})
      : super(key: key);
  final BoardGame boardGame;
  final bool installed;

  @override
  Widget build(BuildContext context) {
    final isImgFromWeb = boardGame.imgUrl.startsWith("http"),
        chips = boardGame.chips;
    return GlassWidget(
      radius: 12.0,
      opacity: 0.41,
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          context.read<MarketPlaceBloc>().add(ChoseBoardGame(boardGame));
          context
              .read<NavBloc>()
              .add(PushNav(pageBuilder: (_) => const DetailMarketPage()));
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          IntrinsicHeight(
            child: Row(
              children: [
                SizedBox(
                    height: 56.0,
                    width: 56.0,
                    child: isImgFromWeb
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(boardGame.imgUrl))
                        : Padding(
                            padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                            child: SvgPicture.asset(boardGame.imgUrl),
                          )),
                if (installed)
                  Expanded(
                      child: Align(
                          child: Icon(Icons.check),
                          alignment: Alignment.topRight))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(boardGame.name,
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: 18)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              boardGame.teaser,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 12.0, fontWeight: FontWeight.w300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Chip(
                      label: Text(chips[0]),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Theme.of(context).primaryColor),
                  Chip(
                      label: Text(chips[1]),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Theme.of(context).accentColor)
                ]),
          )
        ]),
      ),
    );
  }
}
