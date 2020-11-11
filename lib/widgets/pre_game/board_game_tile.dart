import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/pages/chose_players_page.dart';

class BoardGameTile extends StatelessWidget {
  final BoardGame boardGame;

  const BoardGameTile({@required this.boardGame}) : assert(boardGame != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text(boardGame.name),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          context.bloc<CurrentGameBloc>()
            ..add(InitModelCurrentGame(boardGame: boardGame));
          context
              .bloc<NavBloc>()
              .add(PushNav(pageBuilder: (_) => const ChosePlayersPage()));
        },
      ),
    );
  }
}
