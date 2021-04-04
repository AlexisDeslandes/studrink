import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayerOverlay extends StatefulWidget {
  final String name;
  final Color? color;
  final Uint8List? picture;

  const PlayerOverlay({required this.name, this.picture, this.color})
      : assert((picture != null || color != null));

  @override
  _PlayerOverlayState createState() => _PlayerOverlayState();
}

class _PlayerOverlayState extends State<PlayerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1300));
    _slideAnimation = _animationController
        .drive(Tween(begin: Offset(0.0, 0.2), end: Offset(0.0, -0.2)));
    _fadeAnimation = _animationController.drive(TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 0.5),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 0.5)
    ]));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 1 / 2;
    return Center(
        child: SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Card(
            key: ValueKey(widget.name),
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Theme.of(context).primaryColor
                        ])),
                child: Column(children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(100),
                          child: ClipOval(
                              child: widget.picture != null
                                  ? Image.memory(widget.picture!)
                                  : Container(
                                      color: widget.color,
                                      width: size * 0.5,
                                      height: size * 0.5))),
                    ),
                  )),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Text("${widget.name}"))
                ]))),
      ),
    ));
  }
}
