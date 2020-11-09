import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/focused_cell_bloc/focused_cell_bloc.dart';
import 'package:ptit_godet/blocs/game_page_view_bloc/game_page_view_bloc.dart';

class GamePageProvider extends StatelessWidget {
  final Widget child;

  const GamePageProvider({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => FocusedCellBloc()),
      BlocProvider(create: (context) {
        return GamePageViewBloc(
            pageController: PageController(),
            focusedCellBloc: context.bloc<FocusedCellBloc>(),
            currentGameBloc: context.bloc<CurrentGameBloc>());
      }),
    ], child: child);
  }
}
