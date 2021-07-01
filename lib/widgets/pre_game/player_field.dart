import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/models/player.dart';

class PlayerField extends StatefulWidget {
  final Player player;

  const PlayerField(this.player);

  @override
  _PlayerFieldState createState() => _PlayerFieldState();
}

class _PlayerFieldState extends State<PlayerField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.player.name);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PlayerField oldWidget) {
    _controller.value = _controller.value.copyWith(text: widget.player.name);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: Colors.black),
      child: TextField(
        cursorColor: Colors.black,
        decoration: InputDecoration(
            labelText: "Pseudo",
            labelStyle: TextStyle(color: Colors.black),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor))),
        controller: _controller,
        onChanged: (value) => context
            .read<CurrentGameBloc>()
            .add(ChangeNamePlayer(player: widget.player, name: value)),
      ),
    );
  }
}
