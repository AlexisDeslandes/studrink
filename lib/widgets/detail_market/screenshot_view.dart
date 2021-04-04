import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScreenshotView extends StatefulWidget {
  final List<String> screenshots;

  const ScreenshotView({Key? key, required this.screenshots})
      : assert(screenshots != null),
        super(key: key);

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
    final screenshot = widget.screenshots[index];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          padding: EdgeInsets.symmetric(vertical: _idFocus == index ? 0 : 20),
          duration: Duration(milliseconds: 400),
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width * (9 / 16),
          child: Card(
            elevation: 5,
            child: Image.asset(
              "assets/screenshots/$screenshot",
            ),
          ),
        ),
      ),
    );
  }
}
