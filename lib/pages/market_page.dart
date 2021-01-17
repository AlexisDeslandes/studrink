import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                hintText: "Rechercher ou saisir un code",
                prefixIcon: Icon(Icons.search)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              ChoiceChip(
                label: Text("Top des jeux"),
                selected: true,
                elevation: 2,
                onSelected: (_) {},
              ),
              ChoiceChip(label: Text("Evénements"), selected: false),
              ChoiceChip(label: Text("Nouveaux"), selected: false)
            ],
          ),
        ),
        Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 20.0),
                itemBuilder: (context, index) {
                  return MarketGameTile(index: index);
                },
                itemCount: 5))
      ]),
    );
  }

  @override
  String titleContent() {
    return "Market place";
  }
}

class MarketGameTile extends StatelessWidget {
  final int index;

  const MarketGameTile({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                child: Icon(Icons.close),
              ),
            ),
          ),
          Expanded(
            child: Align(
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Column(
                    children: [
                      Text(
                        "Titre $index",
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            .copyWith(fontSize: 14),
                      ),
                      Text(
                        "Sous-titres $index",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        "4,4*",
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
    );
  }
}
