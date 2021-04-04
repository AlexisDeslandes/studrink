import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/models/board_game.dart';

class BoardGameTile extends StatelessWidget {
  final BoardGame boardGame;
  final void Function() onTap;

  const BoardGameTile({required this.boardGame, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text(boardGame.name),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
