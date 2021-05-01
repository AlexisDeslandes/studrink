import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/widgets/glass/glass_widget.dart';

class BoardGameTile extends StatelessWidget {
  final BoardGame boardGame;
  final void Function() onTap;

  const BoardGameTile({required this.boardGame, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imgUrl = boardGame.imgUrl;
    return GlassWidget(
        radius: 13.0,
        child: ListTile(
          leading: imgUrl.contains("http")
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    boardGame.imgUrl,
                    width: 46.0,
                    height: 46.0,
                  ))
              : imgUrl.contains(".svg")
                  ? SvgPicture.asset(
                      imgUrl,
                      height: 46.0,
                      width: 46.0,
                    )
                  : Image.asset(imgUrl),
          title: Text(
            boardGame.name,
            style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.w300,
                fontSize: 22,
                color: Colors.black),
          ),
          trailing: Icon(Icons.chevron_right),
          onTap: onTap,
        ));
  }
}
