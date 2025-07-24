import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/nav/nav_bloc.dart';

/// [BackBtnWrapper] is a mixin to used on every
/// screen state of BIM module.
/// It permits to catch Android back button event and call [NavBloc] [PopNav].
mixin BackBtnWrapper<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(backBtnInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(backBtnInterceptor);
    super.dispose();
  }

  bool backBtnInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (stopDefaultButtonEvent) return false;
    // If app show hamburger menu
    if (context.read<NavBloc>().state.navStateElementList.length == 1) {
      final content = "Êtes-vous sûr de vouloir quitter l'application ?";
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                "Avertissement",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content:
                  Text(content, style: Theme.of(context).textTheme.bodyMedium),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text("NON",
                        style:
                            TextStyle(color: Theme.of(context).primaryColor))),
                TextButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: Text("OUI", style: TextStyle(color: Colors.black)))
              ],
            );
          });
    } else
      context.read<NavBloc>().add(const PopNav());
    return true;
  }
}
