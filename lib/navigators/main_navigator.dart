import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';

class MainNavigator extends StatelessWidget {
  const MainNavigator();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) => Navigator(
        pages: state.navStateElementList
            .map((e) => e.pageBuilder(e.args))
            .toList(),
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return true;
        },
      ),
    );
  }
}
