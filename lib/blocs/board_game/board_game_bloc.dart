import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/storage/local_storage.dart';

class BoardGameBloc extends Bloc<BoardGameEvent, BoardGameState> {
  final LocalStorage storage;

  BoardGameBloc({@required LocalStorage storage})
      : storage = storage,
        super(BoardGameState.empty());

  @override
  Stream<BoardGameState> mapEventToState(BoardGameEvent event) async* {
    if (event is InitBoardGame) {
      Iterable boardGameListAsIterable =
          jsonDecode(storage.read(LocalStorageKeywords.boardGameList));
      final list = List<Map<String, dynamic>>.from(boardGameListAsIterable)
          .map((m) => BoardGame.fromJson(m))
          .toList();
      yield BoardGameState(boardGameList: list);
    }
  }
}

class BoardGameState extends Equatable {
  final List<BoardGame> boardGameList;

  const BoardGameState({@required this.boardGameList});

  const BoardGameState.empty() : boardGameList = const [];

  @override
  List<Object> get props => [boardGameList];
}

abstract class BoardGameEvent extends Equatable {
  const BoardGameEvent();

  @override
  List<Object> get props => [];
}

class InitBoardGame extends BoardGameEvent {
  const InitBoardGame();
}
