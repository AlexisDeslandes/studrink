import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptit_godet/blocs/market_place/market_place_bloc.dart';
import 'package:ptit_godet/widgets/base_screen.dart';
import 'package:ptit_godet/widgets/detail_market/screenshot_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailMarketPage extends CupertinoPage {
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

class DetailMarketScreenState extends BaseScreenState {

  @override
  String get subTitle => "";

  @override
  String get title => "Détail";

  @override
  Widget body(BuildContext context) {
    final boardGame = context
        .read<MarketPlaceBloc>()
        .state
        .chosenBoardGame!,
        imgUrl = boardGame.imgUrl;
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30.0),
      child: Column(
        children: [
          Row(
            children: [
              Card(
                elevation: 3,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: imgUrl.startsWith("http")
                    ? ClipRRect(
                    borderRadius: BorderRadius.circular(3.0),
                    child: Image.network(imgUrl, width: 60.0, height: 60.0))
                    : Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset(
                    imgUrl,
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
              ),
              Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(boardGame.name,
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline2),
                    ),
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonTheme(
                    minWidth: MediaQuery
                        .of(context)
                        .size
                        .width * 0.35,
                    height: 40.0,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Evaluer",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                              fontSize: 18.0,
                              color: Theme
                                  .of(context)
                                  .primaryColor),
                        ))),
                ButtonTheme(
                    minWidth: MediaQuery
                        .of(context)
                        .size
                        .width * 0.35,
                    height: 40.0,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Installer",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                              fontSize: 18.0,
                              color: Theme
                                  .of(context)
                                  .scaffoldBackgroundColor),
                        )))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Text(
              boardGame.description,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: ScreenshotView(screenshots: boardGame.screenshots)),
          )
        ],
      ),
    );
  }


}
