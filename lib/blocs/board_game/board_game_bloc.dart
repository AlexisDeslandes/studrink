import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/models/board_game.dart';

class BoardGameBloc extends Bloc<BoardGameEvent, BoardGameState> {
  BoardGameBloc() : super(BoardGameState.empty());

  @override
  Stream<BoardGameState> mapEventToState(BoardGameEvent event) async* {}
}

class BoardGameState extends Equatable {
  final List<BoardGame> boardGameList;

  const BoardGameState({@required this.boardGameList});

  const BoardGameState.empty() : boardGameList = const [];

  @override
  List<Object> get props => [boardGameList];
}

class BoardGameEvent {}
