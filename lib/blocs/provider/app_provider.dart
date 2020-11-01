import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ptit_godet/blocs/board_game/board_game_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';

class AppProvider extends StatelessWidget {
  final Widget child;

  const AppProvider({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      BlocProvider<NavBloc>(create: (context) => NavBloc()),
      BlocProvider<BoardGameBloc>(create: (context) => BoardGameBloc())
    ], child: child);
  }
}
