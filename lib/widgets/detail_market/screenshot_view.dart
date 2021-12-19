import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studrink/blocs/nav/nav_bloc.dart';
import 'package:studrink/models/cell.dart';
import 'package:studrink/utils/studrink_utils.dart';
import 'package:studrink/widgets/game_page_view/card_cell.dart';

typedef ImagePickScreenshotView = void Function(
    PageBuilder builder, dynamic args);

class ScreenshotView extends StatefulWidget {
  final ImagePickScreenshotView pickImage;
  final List<Cell> cells;

  const ScreenshotView(
      {Key? key, required this.pickImage, this.cells = const []})
      : super(key: key);

  @override
  _ScreenshotViewState createState() => _ScreenshotViewState();
}

class _ScreenshotViewState extends State<ScreenshotView> {
  late PageController _pageController =
      PageController(viewportFraction: isTablet(context) ? 0.3 : 0.7);
  int _idFocus = 0;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: _pageController,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.cells.length,
        onPageChanged: (value) {
          setState(() {
            _idFocus = value;
          });
        },
        itemBuilder: (context, index) {
          final isFocused = _idFocus == index;
          final double top = isFocused ? 20 : 100;
          const horizontalPadding = 15.0;
          return AnimatedContainer(
              margin: EdgeInsets.only(
                  top: top,
                  bottom: 20.0,
                  right: horizontalPadding,
                  left: horizontalPadding),
              curve: Curves.easeOutQuint,
              duration: Duration(milliseconds: 500),
              child: CardCell(cell: widget.cells[index]));
        });
  }
}
