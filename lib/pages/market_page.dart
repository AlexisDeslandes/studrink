import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studrink/blocs/board_game/board_game_bloc.dart';
import 'package:studrink/blocs/market_place/market_place_bloc.dart';
import 'package:studrink/blocs/nav/nav_bloc.dart';
import 'package:studrink/models/board_game.dart';
import 'package:studrink/navigators/widgets/back_btn_wrapper.dart';
import 'package:studrink/pages/detail_market_page.dart';
import 'package:studrink/pages/my_custom_page.dart';
import 'package:studrink/pages/qr_code_page.dart';
import 'package:studrink/utils/studrink_utils.dart';
import 'package:studrink/widgets/buttons/sd_fab.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';
import 'package:studrink/widgets/my_choice_chip.dart';

///
/// Page that contains market place of P'tit godet.
///
class MarketPage extends MyCustomPage {
  const MarketPage()
      : super(child: const MarketScreen(), key: const ValueKey("/market"));
}

class MarketScreen extends StatefulWidget {
  const MarketScreen();

  @override
  State<StatefulWidget> createState() => MarketScreenState();
}

class MarketScreenState extends State<MarketScreen>
    with TickerProviderStateMixin, BackBtnWrapper {
  late final TextEditingController _searchController = TextEditingController(
      text: context.read<MarketPlaceBloc>().state.searchWord);
  late final _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 600))
        ..forward();

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isATablet = isTablet(context),
        width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: ScaleTransition(
        scale: _controller.drive(CurveTween(curve: Interval(0.8, 1.0))),
        child: SDFab(
          icon: Icons.qr_code,
          onPressed: () => _controller.reverse().then((_) => context
              .read<NavBloc>()
              .add(PushNav(
                  pageBuilder: (_) => const QRCodePage(),
                  onPop: () => _controller.forward()))),
          heroTag: "market_fab",
        ),
      ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: isATablet ? width * 0.4 : width * 0.6,
                child: SlideTransition(
                  position: _controller
                      .drive(CurveTween(curve: Interval(0.0, 0.5)))
                      .drive(Tween(begin: Offset(0.0, -0.4), end: Offset.zero)),
                  child: FadeTransition(
                    opacity: _controller
                        .drive(CurveTween(curve: Interval(0.0, 0.5))),
                    child: GlassWidget(
                      border: false,
                      radius: 12,
                      opacity: 0.5,
                      child: TextField(
                        cursorColor: Color(0xffFF71585A),
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
                            prefixIcon:
                                Icon(Icons.search, color: Color(0xffFF71585A)),
                            suffixIcon: IconButton(
                              icon:
                                  Icon(Icons.clear, color: Color(0xffFF71585A)),
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
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: SlideTransition(
                    position: _controller
                        .drive(CurveTween(curve: Interval(0.0, 0.5)))
                        .drive(
                            Tween(begin: Offset(0.0, -0.4), end: Offset.zero)),
                    child: FadeTransition(
                      opacity: _controller
                          .drive(CurveTween(curve: Interval(0.0, 0.5))),
                      child: BlocBuilder<MarketPlaceBloc, MarketPlaceState>(
                          buildWhen: (previous, current) =>
                              previous.selectedSort != current.selectedSort,
                          builder: (context, state) => Wrap(
                              children: MarketSort.values
                                  .map((sort) => MyChoiceChip(
                                      position: sort.position,
                                      label: sort.description,
                                      selected: state.selectedSort == sort,
                                      onSelected: (_) => context
                                          .read<MarketPlaceBloc>()
                                          .add(ChangeMarketSort(sort))))
                                  .toList())),
                    ),
                  )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: FadeTransition(
                  opacity:
                      _controller.drive(CurveTween(curve: Interval(0.5, 1.0))),
                  child: BlocBuilder<MarketPlaceBloc, MarketPlaceState>(
                      builder: (context, state) {
                    final boardGameListTreated = state.boardGameListTreated;
                    return BlocBuilder<BoardGameBloc, BoardGameState>(
                      builder: (context, boardGameState) => GridView.builder(
                        itemCount: boardGameListTreated.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          final boardGame = boardGameListTreated[index];
                          return MarketGameTile(
                              onTap: (value) {
                                boardGame.screenshots.forEach((element) =>
                                    precacheImage(
                                        AssetImage(
                                            "assets/screenshots/$element"),
                                        context));
                                context
                                    .read<MarketPlaceBloc>()
                                    .add(ChoseBoardGame(boardGame));
                                _controller.reverse().then((value) => context
                                    .read<NavBloc>()
                                    .add(PushNav(
                                        pageBuilder: (_) =>
                                            const DetailMarketPage(),
                                        onPop: () => _controller.forward())));
                              },
                              boardGame: boardGame);
                        },
                      ),
                    );
                  }),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class MarketGameTile extends StatelessWidget {
  const MarketGameTile({Key? key, required this.boardGame, required this.onTap})
      : super(key: key);
  final BoardGame boardGame;
  final ValueChanged<BoardGame> onTap;

  @override
  Widget build(BuildContext context) {
    final isImgFromWeb = boardGame.imgUrl.startsWith("http"),
        chips = boardGame.chips;
    return GlassWidget(
      width: 160,
      radius: 12.0,
      opacity: 0.41,
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => onTap(boardGame),
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
                            child: CachedNetworkImage(
                              imageUrl: boardGame.imgUrl,
                              fadeInDuration: Duration.zero,
                            ))
                        : Padding(
                            padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                            child: SvgPicture.asset(boardGame.imgUrl),
                          )),
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
