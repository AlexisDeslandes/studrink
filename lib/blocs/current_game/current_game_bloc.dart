import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/models/cell.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/pages/game_page.dart';

class CurrentGameBloc extends Bloc<CurrentGameEvent, CurrentGameState> {
  final NavBloc navBloc;

  CurrentGameBloc({@required this.navBloc})
      : assert(navBloc != null),
        super(CurrentGameState.empty());

  @override
  Stream<CurrentGameState> mapEventToState(CurrentGameEvent event) async* {
    if (event is InitModelCurrentGame) {
      yield CurrentGameState.copy(state, boardGame: event.boardGame);
    } else if (event is AddPlayer) {
      final playerList = [Player(), ...state.playerList];
      yield CurrentGameState.copy(state, playerList: playerList);
    } else if (event is ChangeNamePlayer) {
      final playerList = state.playerList.map((player) {
        if (player == event.player) {
          return Player.copy(player, name: event.name);
        }
        return player;
      }).toList();
      yield CurrentGameState.copy(state, playerList: playerList);
    } else if (event is ValidateGame) {
      if (state.playerList.every((element) => element.filled)) {
        navBloc.add(PushNav(pageBuilder: (_) => const GamePage()));
      } else {
        //emit alert
      }
    } else if (event is ThrowDice) {
      Random random = Random();
      int diceValue = random.nextInt(6) + 1;
      final currentPlayer = state.currentPlayer,
          idNextCell = currentPlayer.idCurrentCell + diceValue,
          nextCell = state.boardGame.cells[idNextCell],
          nextCellType = nextCell.cellType;
      final playerState = _playerStateFromCellType(nextCellType);
      final playerList = state.playerList.map((player) {
        if (player == currentPlayer) {
          return Player.copy(player,
              idCurrentCell: idNextCell, state: playerState);
        }
        return player;
      }).toList();
      yield CurrentGameState.copy(state, playerList: playerList);
    } else if (event is SwitchToOtherPlayer) {
      final playerList = state.playerList.map((player) {
        if (player == state.currentPlayer) {
          return Player.copy(player, state: PlayerState.ready);
        }
        return player;
      }).toList();
      yield CurrentGameState.copy(state,
          playerList: playerList, indexCurrentPlayer: state.nextIndexPlayer);
    }
  }

  PlayerState _playerStateFromCellType(CellType nextCellType) {
    if (nextCellType == CellType.noEffect) {
      return PlayerState.canEnd;
    }
    return PlayerState.canEnd;
  }
}

abstract class CurrentGameEvent extends Equatable {
  const CurrentGameEvent();

  @override
  List<Object> get props => [];
}

class InitModelCurrentGame extends CurrentGameEvent {
  final BoardGame boardGame;

  const InitModelCurrentGame({@required this.boardGame})
      : assert(boardGame != null);
}

class AddPlayer extends CurrentGameEvent {
  const AddPlayer();
}

class ThrowDice extends CurrentGameEvent {
  const ThrowDice();
}

class SwitchToOtherPlayer extends CurrentGameEvent {
  const SwitchToOtherPlayer();
}

class ChangeNamePlayer extends CurrentGameEvent {
  final Player player;
  final String name;

  const ChangeNamePlayer({@required this.player, @required this.name})
      : assert(player != null && name != null);

  @override
  List<Object> get props => [player, name];
}

class ValidateGame extends CurrentGameEvent {
  const ValidateGame();
}

class CurrentGameState extends Equatable {
  final BoardGame boardGame;
  final List<Player> playerList;
  final int indexCurrentPlayer;

  const CurrentGameState(
      {this.boardGame,
      this.playerList = const [],
      this.indexCurrentPlayer = 0});

  CurrentGameState.empty() : this(playerList: [Player(name: "Pseudo")]);

  @override
  List<Object> get props => [boardGame, playerList, indexCurrentPlayer];

  CurrentGameState.copy(CurrentGameState old,
      {BoardGame boardGame, List<Player> playerList, int indexCurrentPlayer})
      : this(
            boardGame: boardGame ?? old.boardGame,
            indexCurrentPlayer: indexCurrentPlayer ?? old.indexCurrentPlayer,
            playerList: playerList ?? old.playerList);

  get currentCellName =>
      boardGame.cells[playerList[indexCurrentPlayer].idCurrentCell].name;

  Player get currentPlayer => playerList[indexCurrentPlayer];

  Cell get currentCell => boardGame.cells[currentPlayer.idCurrentCell];

  get nextIndexPlayer {
    if (indexCurrentPlayer == playerList.length - 1) {
      return 0;
    }
    return indexCurrentPlayer + 1;
  }
}
