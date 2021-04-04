import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator();

  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  late final StreamSubscription<String> _errorSubscription;

  @override
  void initState() {
    super.initState();
    _errorSubscription =
        context.read<CurrentGameBloc>().errorStream.listen((event) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text("Erreur rencontrée"),
              content: Text(event),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: Text("OK"))
              ],
            );
          });
    });
  }

  @override
  void dispose() {
    _errorSubscription.cancel();
    super.dispose();
  }

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
