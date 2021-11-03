import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/blocs/game_page_view_bloc/game_page_view_bloc.dart';

class GameSlider extends StatefulWidget {
  const GameSlider({Key? key}) : super(key: key);

  @override
  _GameSliderState createState() => _GameSliderState();
}

class _GameSliderState extends State<GameSlider> {
  double _value = 0;
  bool _isSliding = false;
  late int _cellsCount =
      context.read<CurrentGameBloc>().state.boardGame!.cells.length;
  late final PageController _controller =
      context.read<GamePageViewBloc>().state.pageController;
  late final _listener;

  //todo fix issue
  //setState() called after dispose(): _GameSliderState#e62ed(lifecycle state: defunct, not mounted)

  @override
  void initState() {
    super.initState();
    _controller.addListener(_listener = () {
      if (!_isSliding) setState(() => _value = _controller.page!);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //todo remonter le titre pour créer de l'espace, trouver un moyen
    // de rajouter les users au dessus du game slider
    return SliderTheme(
        data: SliderThemeData(inactiveTrackColor: Color(0x84188297)),
        child: Slider(
            divisions: _cellsCount,
            value: _value,
            activeColor: Theme.of(context).primaryColor,
            onChangeStart: (value) => _isSliding = true,
            onChangeEnd: (value) => _isSliding = false,
            onChanged: (value) {
              final intValue = value.toInt();
              context.read<GamePageViewBloc>().add(ChangePageView(intValue,
                  duration: Duration(milliseconds: 200)));
              setState(() => _value = value);
            },
            min: 0,
            max: _cellsCount.toDouble()));
  }
}
