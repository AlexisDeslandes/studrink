import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';

class AddPlayerButton extends StatelessWidget {
  const AddPlayerButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "add_player",
      mini: true,
      child: Icon(Icons.add, color: Theme.of(context).primaryColor),
      onPressed: () => context.read<CurrentGameBloc>().add(AddPlayer()),
    );
  }
}
