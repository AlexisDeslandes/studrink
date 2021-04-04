import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/pages/home_page.dart';

typedef CupertinoPage PageBuilder(dynamic);

class NavStateElement extends Equatable {
  final dynamic args;
  final PageBuilder pageBuilder;

  const NavStateElement({required this.pageBuilder, this.args});

  @override
  List<Object> get props => [pageBuilder, args];
}

class NavState extends Equatable {
  final List<NavStateElement> navStateElementList;

  NavState(this.navStateElementList);

  @override
  List<Object> get props => [navStateElementList];
}

abstract class NavEvent extends Equatable {
  const NavEvent();

  @override
  List<Object> get props => [];
}

class PushNav extends NavEvent {
  final dynamic args;
  final PageBuilder pageBuilder;

  const PushNav({required this.pageBuilder, this.args});

  @override
  List<Object> get props => [pageBuilder, args];
}

class PopNav extends NavEvent {
  const PopNav();
}

class ResetNavToHome extends NavEvent {
  const ResetNavToHome();
}

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc()
      : super(
            NavState([NavStateElement(pageBuilder: (_) => const HomePage())]));

  @override
  Stream<NavState> mapEventToState(NavEvent event) async* {
    final currentNavList = state.navStateElementList;
    if (event is PushNav) {
      yield NavState([
        ...currentNavList,
        NavStateElement(pageBuilder: event.pageBuilder, args: event.args)
      ]);
    } else if (event is PopNav) {
      yield NavState(currentNavList.sublist(0, currentNavList.length - 1));
    } else {
      yield NavState([NavStateElement(pageBuilder: (_) => const HomePage())]);
    }
  }
}
