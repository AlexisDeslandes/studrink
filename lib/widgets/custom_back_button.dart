import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.chevron_left),
      iconSize: 50.0,
      onPressed: () => context.bloc<NavBloc>().add(const PopNav()),
    );
  }
}
