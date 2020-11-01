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
  final TextEditingController _controller = TextEditingController();

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
    return TextField(
      decoration: InputDecoration(labelText: "Pseudo"),
      controller: _controller,
      onChanged: (value) => context
          .bloc<CurrentGameBloc>()
          .add(ChangeNamePlayer(player: widget.player, name: value)),
    );
  }
}
