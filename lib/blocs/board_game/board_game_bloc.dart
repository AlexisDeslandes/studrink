import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:studrink/blocs/bloc_emitter.dart';
import 'package:studrink/models/board_game.dart';
import 'package:studrink/storage/local_storage.dart';

class BoardGameBloc extends BlocEmitter<BoardGameEvent, BoardGameState>
    with SnackBarBloc {
  final LocalStorage storage;
  final AssetBundle assetBundle;

  BoardGameBloc({required LocalStorage storage, AssetBundle? assetBundle})
      : storage = storage,
        assetBundle = assetBundle ?? rootBundle,
        super(BoardGameState.empty());

  @override
  Stream<BoardGameState> mapEventToState(BoardGameEvent event) async* {
    if (event is InitBoardGame) {
      final gamesAsString =
          await assetBundle.loadString("assets/games/games.json");
      final List<Map<String, dynamic>> gamesAsJson =
          (jsonDecode(gamesAsString) as List<dynamic>)
              .cast<Map<String, dynamic>>();
      final boardGameList =
          gamesAsJson.map((json) => BoardGame.fromJson(json)).toList();
      yield BoardGameState(boardGameList: boardGameList);
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
