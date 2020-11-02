import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/models/cell.dart';
import 'package:ptit_godet/models/moving.dart';
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
      yield CurrentGameState.copy(state,
          playerList: [Player(), ...state.playerList]);
    } else if (event is ChangeNamePlayer) {
      yield* _changeNamePlayer(event);
    } else if (event is ValidateGame) {
      yield* _validateGame(event);
    } else if (event is ThrowDice) {
      final random = Random(), diceValue = random.nextInt(6) + 1;
      yield* _throwDice(diceValue);
    } else if (event is SwitchToOtherPlayer) {
      yield* _switchToOtherPlayer(event);
    } else if (event is ReturnPreviousCheckpoint) {
      yield* _returnPreviousCheckpoint();
    } else if (event is MovePlayer) {
      yield* _movePlayer();
    }
  }

  PlayerState _playerStateFromCellType(Cell nextCell) {
    final nextCellType = nextCell.cellType;
    if (nextCellType == CellType.conditionKey) {
      if (!state.currentPlayer.conditionKeyList
          .contains(nextCell.requiredConditionKey)) {
        return PlayerState.returnPreviousCheckPoint;
      }
    } else if (nextCellType == CellType.selfMoving) {
      return PlayerState.moving;
    } else if (nextCellType == CellType.turnLose) {
      return PlayerState.preTurnLost;
    }
    return PlayerState.canEnd;
  }

  Stream<CurrentGameState> _throwDice(int diceValue) async* {
    final currentPlayer = state.currentPlayer,
        idNextCell = _getNextCell(currentPlayer.idCurrentCell, diceValue),
        nextCell = state.boardGame.cells[idNextCell],
        nextPlayerState = _playerStateFromCellType(nextCell);

    final playerList = state.playerList.map((player) {
      if (player == currentPlayer) {
        return Player.copy(player,
            idCurrentCell: idNextCell,
            state: nextPlayerState,
            conditionKeyList: [
              nextCell.givenConditionKey,
              ...player.conditionKeyList
            ]);
      }
      return player;
    }).toList();

    yield CurrentGameState.copy(state, playerList: playerList);
  }

  Stream<CurrentGameState> _changeNamePlayer(ChangeNamePlayer event) async* {
    final playerList = state.playerList.map((player) {
      if (player == event.player) {
        return Player.copy(player, name: event.name);
      }
      return player;
    }).toList();
    yield CurrentGameState.copy(state, playerList: playerList);
  }

  Stream<CurrentGameState> _validateGame(ValidateGame event) async* {
    if (state.playerList.every((element) => element.filled)) {
      navBloc.add(PushNav(pageBuilder: (_) => const GamePage()));
    } else {
      //emit alert
    }
  }

  Stream<CurrentGameState> _switchToOtherPlayer(
      SwitchToOtherPlayer event) async* {
    final playerList = state.playerList.map((player) {
      var newState;
      if (player == state.currentPlayer) {
        switch (player.state) {
          case PlayerState.preTurnLost:
            newState = PlayerState.turnLost;
            break;
          default:
            newState = PlayerState.ready;
            break;
        }
        return Player.copy(player, state: newState);
      }
      return player;
    }).toList();
    yield CurrentGameState.copy(state,
        playerList: playerList, indexCurrentPlayer: state.nextIndexPlayer);
  }

  int _getNextCell(int idCurrentCell, int diceValue) {
    for (var i = idCurrentCell + 1; i < idCurrentCell + diceValue; i++) {
      if (state.boardGame.cells[i].cellType == CellType.conditionKey) {
        return i;
      }
    }
    return idCurrentCell + diceValue;
  }

  Stream<CurrentGameState> _returnPreviousCheckpoint() async* {
    final playerList = state.playerList.map((player) {
      if (player == state.currentPlayer) {
        return Player.copy(player,
            idCurrentCell: _previousCheckpointId(player),
            state: PlayerState.canEnd);
      }
      return player;
    }).toList();
    yield CurrentGameState.copy(state, playerList: playerList);
  }

  int _previousCheckpointId(Player player) {
    int idCellPlayer = player.idCurrentCell;
    for (var i = idCellPlayer - 1; i >= 0; i--) {
      if (state.boardGame.cells[i].cellType == CellType.conditionKey) {
        return i;
      }
    }
    return 0;
  }

  Stream<CurrentGameState> _movePlayer() async* {
    final moving = state.currentCell.moving, count = moving.count;
    yield* _throwDice(moving.movingType == MovingType.forward ? count : -count);
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

class ReturnPreviousCheckpoint extends CurrentGameEvent {
  const ReturnPreviousCheckpoint();
}

class SwitchToOtherPlayer extends CurrentGameEvent {
  const SwitchToOtherPlayer();
}

class MovePlayer extends CurrentGameEvent {
  const MovePlayer();
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

  Player get nextPlayer => playerList[nextIndexPlayer];
}
