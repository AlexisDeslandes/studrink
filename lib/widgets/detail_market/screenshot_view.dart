import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/extension/string_extension.dart';
import 'package:ptit_godet/pages/image_detail_page.dart';

typedef ImagePickScreenshotView = void Function(
    PageBuilder builder, dynamic args);

class ScreenshotView extends StatefulWidget {
  final List<String> screenshots;
  final ImagePickScreenshotView pickImage;

  const ScreenshotView(
      {Key? key, required this.screenshots, required this.pickImage})
      : super(key: key);

  @override
  _ScreenshotViewState createState() => _ScreenshotViewState();
}

class _ScreenshotViewState extends State<ScreenshotView> {
  PageController _pageController = PageController(viewportFraction: 0.7);
  int _idFocus = 0;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: _pageController,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.screenshots.length,
        onPageChanged: (value) {
          setState(() {
            _idFocus = value;
          });
        },
        itemBuilder: _buildScreenshotCard);
  }

  Widget _buildScreenshotCard(BuildContext context, int index) {
    final screenshot = widget.screenshots[index],
        pathToScreenshot = "assets/screenshots/$screenshot",
        heroTag = StringExtension.generateRandomString();
    final isFocused = _idFocus == index;
    final double blur = isFocused ? 20 : 0;
    final double offset = isFocused ? 2 : 0;
    final double top = isFocused ? 20 : 100;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Hero(
          tag: heroTag,
          child: AnimatedContainer(
              child: Material(
                child: InkWell(
                    onTap: () => widget.pickImage(
                        (path) => ImageDetailPage(path: path, heroTag: heroTag),
                        pathToScreenshot),
                    borderRadius: BorderRadius.circular(20)),
              ),
              margin:
                  EdgeInsets.only(top: top, bottom: 20.0, right: 15, left: 15),
              curve: Curves.easeOutQuint,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      fit: BoxFit.fill, image: AssetImage(pathToScreenshot)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black87,
                        blurRadius: blur,
                        offset: Offset(offset, offset))
                  ]),
              duration: Duration(milliseconds: 500)),
        ),
      ),
    );
  }
}
