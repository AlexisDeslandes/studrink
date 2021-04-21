import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptit_godet/blocs/market_place/market_place_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/pages/detail_market_page.dart';
import 'package:ptit_godet/widgets/base_screen.dart';
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
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(
              onPressed: () => context.read<NavBloc>().add(const PopNav()),
              color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
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
                  onChanged: (value) =>
                      context.read<MarketPlaceBloc>().add(SearchMarket(value)),
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
                          context.read<MarketPlaceBloc>().add(SearchMarket(""));
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
                return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 8.0),
                    itemBuilder: (context, index) => MarketGameTile(
                        index: index, boardGame: boardGameListTreated[index]),
                    itemCount: boardGameListTreated.length);
              }),
            ))
          ],
        ),
      ),
    ));
  }
}

class MarketGameTile extends StatelessWidget {
  final BoardGame boardGame;
  final int index;

  const MarketGameTile({Key? key, required this.boardGame, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImgFromWeb = boardGame.imgUrl.startsWith("http");
    return GlassWidget(
      radius: 12.0,
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15),
      child: InkWell(
        onTap: () {
          context.read<MarketPlaceBloc>().add(ChoseBoardGame(boardGame));
          context
              .read<NavBloc>()
              .add(PushNav(pageBuilder: (_) => const DetailMarketPage()));
        },
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text("${index + 1}",
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                      height: 40.0,
                      width: 40.0,
                      child: isImgFromWeb
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(boardGame.imgUrl))
                          : Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: SvgPicture.asset(boardGame.imgUrl),
                            ))),
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
                                ?.copyWith(fontSize: 16),
                          ),
                          Text(boardGame.subTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(fontSize: 12)),
                          Text(boardGame.tag,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black))
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly),
                  ),
                  alignment: Alignment.topLeft,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Icon(Icons.chevron_right),
              )
            ],
          ),
        ),
      ),
    );
  }
}
