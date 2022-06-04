import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/models/cell.dart';
import 'package:studrink/models/player.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';
import 'package:studrink/widgets/player_avatar.dart';

class GridCell extends StatelessWidget {
  const GridCell(
      {Key? key,
      required this.cellIndex,
      required this.cell,
      required this.playerList,
      required this.current})
      : super(key: key);

  //Starting at 0
  final int cellIndex;
  final Cell cell;
  final List<Player> playerList;
  final bool current;

  @override
  Widget build(BuildContext context) {
    Player? currentPlayer;
    if (current) {
      currentPlayer = context.read<CurrentGameBloc>().state.currentPlayer;
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: GlassWidget(
            borderColor: current ? currentPlayer!.color : Colors.white,
            borderWidth: current ? 3 : 1,
            padding: EdgeInsets.all(6),
            child: SvgPicture.asset(
              cell.iconPath,
            ),
          ),
        ),
        if (!(((cellIndex + 3) % 6 == 0) || ((cellIndex + 4) % 6 == 0)))
          Positioned.fill(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    color: Colors.black,
                    width: 4,
                    height: 3,
                  ))),
        if (!(((cellIndex) % 6 == 0) || ((cellIndex + 1) % 6 == 0)))
          Positioned.fill(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    color: Colors.black,
                    width: 4,
                    height: 3,
                  ))),
        if ((cellIndex + 1) % 3 == 0)
          Positioned.fill(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black,
                    width: 4,
                    height: 3,
                  ))),
        if ((cellIndex) % 3 == 0 && cellIndex != 0)
          Positioned.fill(
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: Colors.black,
                    width: 4,
                    height: 3,
                  ))),
        Positioned.fill(
            bottom: 4,
            right: 4,
            child: Align(
              alignment: Alignment.bottomRight,
              child: GlassWidget(
                  padding: EdgeInsets.all(3),
                  child:
                      Text("${cellIndex + 1}", style: TextStyle(fontSize: 15))),
            )),
        Positioned(
            top: 10,
            left: 10,
            //todo adapt size
            child: Wrap(
              spacing: 4,
              children: playerList
                  .map((e) => PlayerAvatar(player: e, size: 30))
                  .toList(),
            ))
      ],
    );
  }
}
