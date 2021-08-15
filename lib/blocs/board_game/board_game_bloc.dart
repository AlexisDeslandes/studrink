import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:studrink/blocs/bloc_emitter.dart';
import 'package:studrink/models/board_game.dart';
import 'package:studrink/storage/local_storage.dart';

class BoardGameBloc extends BlocEmitter<BoardGameEvent, BoardGameState>
    with SnackBarBloc {
  final LocalStorage storage;

  BoardGameBloc({required LocalStorage storage})
      : storage = storage,
        super(BoardGameState.empty());

  @override
  Stream<BoardGameState> mapEventToState(BoardGameEvent event) async* {
    if (event is InitBoardGame) {
      var list = <BoardGame>[];
      final boardGameListEncoded =
          storage.read(LocalStorageKeywords.boardGameList);
      if (boardGameListEncoded != null) {
        Iterable boardGameListAsIterable = jsonDecode(boardGameListEncoded);
        list = List<Map<String, dynamic>>.from(boardGameListAsIterable)
            .map((m) => BoardGame.fromJson(m))
            .toList();
      }
      yield BoardGameState(boardGameList: list);
    } else if (event is AddBoardGame) {
      final boardGame = event.boardGame,
          boardGameList = [...state.boardGameList, boardGame];
      await storage.write(
          LocalStorageKeywords.boardGameList, jsonEncode(boardGameList));
      yield BoardGameState(boardGameList: boardGameList);
      emitSnackBar("Le jeu a bien été ajouté.");
    } else if (event is DeleteBoardGame) {
      final boardGameList = state.boardGameList
          .where((element) => element != event.boardGame)
          .toList();
      await storage.write(
          LocalStorageKeywords.boardGameList, jsonEncode(boardGameList));
      yield BoardGameState(boardGameList: boardGameList);
      emitSnackBar("Le jeu a bien été supprimé.");
    }
  }
}

class BoardGameState extends Equatable {
  final List<BoardGame> boardGameList;

  const BoardGameState({required this.boardGameList});

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

class AddBoardGame extends BoardGameEvent {
  const AddBoardGame(this.boardGame);

  final BoardGame boardGame;
}

class DeleteBoardGame extends BoardGameEvent {
  const DeleteBoardGame(this.boardGame);

  final BoardGame boardGame;
}
