import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/widgets/wrappers/snackbar_state_handler.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator();

  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator>
    with SnackBarStateHandler {
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
              title: Text("Erreur rencontrée",
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
              content:
                  Text(event, style: Theme.of(context).textTheme.bodyText1),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: Text("OK",
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)))
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
        observers: [HeroController()],
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
