import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:studrink/blocs/board_game/board_game_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/blocs/dice/dice_bloc.dart';
import 'package:studrink/blocs/focused_cell_bloc/focused_cell_bloc.dart';
import 'package:studrink/blocs/game_page_view_bloc/game_page_view_bloc.dart';
import 'package:studrink/blocs/nav/nav_bloc.dart';
import 'package:studrink/storage/local_storage.dart';

class AppProvider extends StatelessWidget {
  final Widget child;

  const AppProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const maxWidth = 1400; // => fraction 0.3
    final width = MediaQuery.of(context).size.width,
        fraction = 0.70 - (width > 500 ? (width * (0.35) / maxWidth) : 0.0);
    return MultiProvider(providers: [
      BlocProvider<NavBloc>(create: (context) => NavBloc()),
      BlocProvider<DiceBloc>(create: (context) => DiceBloc()),
      BlocProvider(create: (context) => FocusedCellBloc()),
      BlocProvider<BoardGameBloc>(
          lazy: false,
          create: (context) => BoardGameBloc(storage: LocalStorage())
            ..add(const InitBoardGame())),
      BlocProvider<CurrentGameBloc>(
          create: (context) => CurrentGameBloc(
              focusedCellBloc: context.read<FocusedCellBloc>(),
              navBloc: context.read<NavBloc>(),
              diceBloc: context.read<DiceBloc>())),
      BlocProvider(
          create: (context) => GamePageViewBloc(
              pageController: PageController(viewportFraction: fraction),
              focusedCellBloc: context.read<FocusedCellBloc>(),
              currentGameBloc: context.read<CurrentGameBloc>())),
    ], child: child);
  }
}
