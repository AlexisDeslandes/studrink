import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';

class CustomBackButton extends StatelessWidget {
  final Future<bool> Function(BuildContext)? callback;

  const CustomBackButton({this.callback});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.chevron_left),
      iconSize: 50.0,
      onPressed: () async {
        final result = await callback?.call(context);
        if (result ?? true) {
          context.read<NavBloc>().add(const PopNav());
        }
      },
    );
  }
}
