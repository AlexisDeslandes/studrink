import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/pages/home_page.dart';

typedef Page PageBuilder(dynamic args);

class NavStateElement extends Equatable {
  final dynamic args;
  final PageBuilder pageBuilder;
  final VoidCallback? onPop;

  const NavStateElement({required this.pageBuilder, this.args, this.onPop});

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

class ReplaceNav extends NavEvent {
  final dynamic args;
  final PageBuilder pageBuilder;

  const ReplaceNav({required this.pageBuilder, this.args});

  @override
  List<Object> get props => [pageBuilder, args];
}

class PushNav extends NavEvent {
  final dynamic args;
  final PageBuilder pageBuilder;
  final VoidCallback? onPop;

  const PushNav({required this.pageBuilder, this.args, this.onPop});

  @override
  List<Object> get props => [pageBuilder, args];
}

class ResetNav extends NavEvent {
  final dynamic args;
  final PageBuilder pageBuilder;

  const ResetNav({required this.pageBuilder, this.args});

  @override
  List<Object> get props => [args, pageBuilder];
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
        NavStateElement(
            pageBuilder: event.pageBuilder,
            args: event.args,
            onPop: event.onPop)
      ]);
    } else if (event is ReplaceNav) {
      final lastNavElement = currentNavList.last;
      yield NavState([
        ...currentNavList.sublist(0, currentNavList.length - 1),
        NavStateElement(
            pageBuilder: event.pageBuilder,
            args: event.args,
            onPop: lastNavElement.onPop)
      ]);
    } else if (event is PopNav) {
      final lastNavElement = currentNavList.last;
      yield NavState(currentNavList.sublist(0, currentNavList.length - 1));
      lastNavElement.onPop?.call();
    } else if (event is ResetNav) {
      yield NavState(
          [NavStateElement(pageBuilder: event.pageBuilder, args: event.args)]);
    } else {
      yield NavState([NavStateElement(pageBuilder: (_) => const HomePage())]);
    }
  }
}
