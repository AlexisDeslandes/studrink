import 'dart:math';

import 'package:flutter/material.dart';
import 'package:studrink/models/player.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';
import 'package:studrink/widgets/player_avatar.dart';

class SDGameSlider extends StatefulWidget {
  const SDGameSlider({Key? key}) : super(key: key);

  @override
  _SDGameSliderState createState() => _SDGameSliderState();
}

class _SDGameSliderState extends State<SDGameSlider> {
  double _thumbPosition = 0.0;
  List<Player> _playerList = [
    Player(
      id: 8,
      color: Colors.red,
    ),
    Player(id: 9, color: Colors.orange),
    Player(id: 10, color: Colors.grey)
  ];

  @override
  Widget build(BuildContext context) {
    const heightWidget = 200.0, thumbSize = 30.0;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: heightWidget,
      child: Stack(
        children: [
          Positioned.fill(
              child: Center(
            child: Container(
                height: 10.0,
                width: MediaQuery.of(context).size.width,
                child: GlassWidget(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: _thumbPosition + thumbSize / 2,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(100.0)),
                      ),
                    ),
                    opacity: 0.50)),
          )),
          Positioned(
              top: heightWidget / 2 - thumbSize / 2,
              left: _thumbPosition,
              child: Column(
                children: [
                  GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        _thumbPosition = max(
                            0,
                            min(width - thumbSize,
                                details.globalPosition.dx - thumbSize / 2));
                      });
                    },
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Theme.of(context).primaryColor
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)),
                          width: thumbSize,
                          height: thumbSize),
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 30,
                    color: Colors.white,
                  ),
                ],
              )),
          Positioned(
            left: _thumbPosition > width / 2 //todo animate when mid transition
                ? _thumbPosition -
                    (_playerList.length * 40 + (_playerList.length - 1) * 12)
                : _thumbPosition,
            bottom: 0,
            child: GlassWidget(
                padding: EdgeInsets.all(12.0),
                child: Wrap(
                    spacing: 12.0,
                    children: _playerList
                        .map((e) => PlayerAvatar(player: e))
                        .toList())),
          )
        ],
      ),
    );
  }
}
