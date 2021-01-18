import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ptit_godet/blocs/board_game/board_game_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/dice/dice_bloc.dart';
import 'package:ptit_godet/blocs/market_place/market_place_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/storage/local_storage.dart';

class AppProvider extends StatelessWidget {
  final Widget child;

  const AppProvider({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      BlocProvider<NavBloc>(create: (context) => NavBloc()),
      BlocProvider<DiceBloc>(create: (context) => DiceBloc()),
      BlocProvider<BoardGameBloc>(
          create: (context) => BoardGameBloc(storage: LocalStorage())
            ..add(const InitBoardGame())),
      BlocProvider<CurrentGameBloc>(
          create: (context) => CurrentGameBloc(
              navBloc: context.bloc<NavBloc>(),
              diceBloc: context.bloc<DiceBloc>())),
      BlocProvider<MarketPlaceBloc>(
          create: (context) => MarketPlaceBloc()..add(const InitMarketPlace()))
    ], child: child);
  }
}
