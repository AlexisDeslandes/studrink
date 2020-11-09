import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/models/cell.dart';
import 'package:ptit_godet/models/condition_key.dart';
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
    final uIntList =
        (await rootBundle.load("assets/pp_.png")).buffer.asUint8List();
    if (event is InitModelCurrentGame) {
      yield CurrentGameState.copy(state,
          boardGame: event.boardGame,
          playerList: state.playerList.map((e) {
            return Player.copy(e, avatar: uIntList);
          }).toList());
    } else if (event is AddPlayer) {
      yield CurrentGameState.copy(state,
          playerList: [Player(avatar: uIntList), ...state.playerList]);
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
    } else if (event is FailChallenge) {
      yield* _failChallenge();
    } else if (event is SucceedChallenge) {
      yield* _succeedChallenge();
    } else if (event is MovingForward) {
      yield* _movingForward();
    } else if (event is MoveBack) {
      yield* _moveBack();
    } else if (event is PickOpponent) {
      yield* _pickOpponent(event.player);
    } else if (event is ChoseWinner) {
      yield* _choseWinner(event.player);
    } else if (event is MakePlayerMoving) {
      yield* _makePlayerMoving(event.player);
    } else if (event is StealConditionKey) {
      yield* _stealConditionKey(event.player);
    }
  }

  PlayerState _playerStateFromCellType(Cell nextCell) {
    final nextCellType = nextCell.cellType, currentPlayer = state.currentPlayer;
    if (nextCellType == CellType.conditionKey) {
      final requiredConditionKey = nextCell.requiredConditionKey;
      if (requiredConditionKey == null ||
          !currentPlayer.conditionKeyList.contains(requiredConditionKey)) {
        return PlayerState.returnPreviousCheckPoint;
      }
    } else if (nextCellType == CellType.selfMoving) {
      return PlayerState.moving;
    } else if (nextCellType == CellType.turnLose) {
      return PlayerState.preTurnLost;
    } else if (nextCellType == CellType.selfThrowDice) {
      if (currentPlayer.state != PlayerState.throwDice) {
        return PlayerState.throwDice;
      }
      return PlayerState.thrownDice;
    } else if (nextCellType == CellType.selfChallenge) {
      return PlayerState.selfChallenge;
    } else if (nextCellType == CellType.selfMovingUndetermined) {
      return PlayerState.choseDirection;
    } else if (nextCellType == CellType.battle) {
      return PlayerState.choseOpponent;
    } else if (nextCellType == CellType.otherMoving) {
      return PlayerState.chosePlayerMoving;
    } else if (nextCellType == CellType.steal) {
      return PlayerState.stealConditionKey;
    }
    return PlayerState.canEnd;
  }

  Stream<CurrentGameState> _throwDice(int diceValue,
      {bool force = false}) async* {
    final currentPlayer = state.currentPlayer,
        idNextCell =
            _getNextCell(currentPlayer.idCurrentCell, diceValue, force),
        nextCell = state.boardGame.cells[idNextCell],
        nextPlayerState = _playerStateFromCellType(nextCell),
        conditionKeyList = _getConditionKeyList(nextPlayerState,
            currentPlayer.conditionKeyList, nextCell.givenConditionKey);

    final playerList = state.playerList.map((player) {
      if (player == currentPlayer) {
        return Player.copy(player,
            idCurrentCell: idNextCell,
            state: nextPlayerState,
            conditionKeyList: conditionKeyList);
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

  int _getNextCell(int idCurrentCell, int diceValue, bool force) {
    if (force) {
      return idCurrentCell + diceValue;
    }
    final currentCell = state.currentCell,
        inPrison = currentCell.cellType == CellType.prison;
    if ((inPrison &&
            !currentCell.prisonCondition.dicePossibilities
                .contains(diceValue)) ||
        (state.currentPlayer.state != PlayerState.ready &&
            currentCell.cellType == CellType.selfThrowDice &&
            state.currentPlayer.state != PlayerState.thrownDice)) {
      return idCurrentCell;
    }
    for (var i = idCurrentCell + 1; i < idCurrentCell + diceValue; i++) {
      if (state.boardGame.cells[i].cellType == CellType.conditionKey) {
        return i;
      }
    }
    return idCurrentCell + diceValue;
  }

  Stream<CurrentGameState> _returnPreviousCheckpoint() async* {
    final tpCell = state.currentCell.tpCell;
    var idTpCell;
    if (tpCell != null) {
      idTpCell = state.boardGame.cells
          .indexWhere((element) => element.name == tpCell.name);
    }
    final playerList = state.playerList.map((player) {
      if (player == state.currentPlayer) {
        return Player.copy(player,
            idCurrentCell:
                idTpCell != null ? idTpCell : _previousCheckpointId(player),
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

  Stream<CurrentGameState> _movingForward() async* {
    final movingUndeterminedCount = state.currentCell.movingUndeterminedCount;
    yield* _throwDice(movingUndeterminedCount);
  }

  Stream<CurrentGameState> _moveBack() async* {
    final movingUndeterminedCount = state.currentCell.movingUndeterminedCount;
    yield* _throwDice(-movingUndeterminedCount);
  }

  Stream<CurrentGameState> _failChallenge() async* {
    final playerList = state.playerList.map((player) {
      if (player == state.currentPlayer) {
        return Player.copy(player, state: PlayerState.canEnd);
      }
      return player;
    }).toList();
    yield CurrentGameState.copy(state, playerList: playerList);
  }

  Stream<CurrentGameState> _succeedChallenge() async* {
    final playerList = state.playerList.map((player) {
      if (player == state.currentPlayer) {
        return Player.copy(player,
            state: PlayerState.canEnd,
            conditionKeyList: [
              state.currentCell.givenConditionKey,
              ...player.conditionKeyList
            ]);
      }
      return player;
    }).toList();
    yield CurrentGameState.copy(state, playerList: playerList);
  }

  List<ConditionKey> _getConditionKeyList(PlayerState playerState,
      List<ConditionKey> currentList, ConditionKey givenConditionKey) {
    if ([
      PlayerState.canEnd,
      PlayerState.moving,
      PlayerState.returnPreviousCheckPoint
    ].contains(playerState)) {
      return [givenConditionKey, ...currentList];
    }
    return currentList;
  }

  Stream<CurrentGameState> _pickOpponent(Player player) async* {
    yield CurrentGameState.copy(state,
        playerList: state.playerList.map((playerElem) {
          if (playerElem == state.currentPlayer) {
            return Player.copy(playerElem, state: PlayerState.waitForWinner);
          }
          return playerElem;
        }).toList(),
        currentOpponent: player);
  }

  Stream<CurrentGameState> _choseWinner(Player player) async* {
    yield CurrentGameState.copy(state,
        playerList: state.playerList.map((playerElem) {
          if (playerElem == state.currentPlayer) {
            return Player.copy(playerElem,
                state: PlayerState.ready,
                conditionKeyList: player == playerElem
                    ? [
                        state.currentCell.givenConditionKey,
                        ...player.conditionKeyList
                      ]
                    : player.conditionKeyList);
          } else if (playerElem == player) {
            return Player.copy(player, conditionKeyList: [
              state.currentCell.givenConditionKey,
              ...player.conditionKeyList
            ]);
          }
          return playerElem;
        }).toList(),
        indexCurrentPlayer: state.nextIndexPlayer);
  }

  Stream<CurrentGameState> _makePlayerMoving(Player player) async* {
    final currentCell = state.currentCell,
        moving = currentCell.moving,
        movingCount = moving.count;
    yield CurrentGameState.copy(state,
        indexCurrentPlayer: state.playerList.indexOf(player),
        indexNextPlayer: state.nextIndexPlayer,
        playerList: state.playerList.map((e) {
          if (e == state.currentPlayer) {
            return Player.copy(e, state: PlayerState.ready);
          }
          return e;
        }).toList());
    yield* _throwDice(
        moving.movingType == MovingType.forward ? movingCount : -movingCount,
        force: true);
  }

  Stream<CurrentGameState> _stealConditionKey(Player player) async* {
    final conditionKey = state.currentCell.conditionKeyStolen;
    yield CurrentGameState.copy(state,
        playerList: state.playerList.map((elemPlayer) {
          if (elemPlayer == state.currentPlayer) {
            return Player.copy(elemPlayer,
                state: PlayerState.ready,
                conditionKeyList: [
                  conditionKey,
                  ...elemPlayer.conditionKeyList
                ]);
          } else if (elemPlayer == player) {
            return Player.copy(player,
                conditionKeyList: player.conditionKeyList
                  ..remove(conditionKey));
          }
          return elemPlayer;
        }).toList(),
        indexCurrentPlayer: state.nextIndexPlayer);
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

class FailChallenge extends CurrentGameEvent {
  const FailChallenge();
}

class StealConditionKey extends CurrentGameEvent {
  final Player player;

  const StealConditionKey(this.player);
}

class MovingForward extends CurrentGameEvent {
  const MovingForward();
}

class MakePlayerMoving extends CurrentGameEvent {
  final Player player;

  const MakePlayerMoving(this.player);
}

class MoveBack extends CurrentGameEvent {
  const MoveBack();
}

class PickOpponent extends CurrentGameEvent {
  final Player player;

  const PickOpponent(this.player);
}

class SucceedChallenge extends CurrentGameEvent {
  const SucceedChallenge();
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

class ChoseWinner extends CurrentGameEvent {
  final Player player;

  const ChoseWinner(this.player);
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
  int indexNextPlayer;
  final Player currentOpponent;

  CurrentGameState(
      {this.boardGame,
      this.playerList = const [],
      this.indexNextPlayer,
      this.currentOpponent,
      this.indexCurrentPlayer = 0});

  CurrentGameState.empty() : this(playerList: [Player(name: "Pseudo")]);

  @override
  List<Object> get props =>
      [boardGame, playerList, indexCurrentPlayer, currentOpponent];

  CurrentGameState.copy(CurrentGameState old,
      {BoardGame boardGame,
      List<Player> playerList,
      Player currentOpponent,
      int indexNextPlayer,
      int indexCurrentPlayer})
      : this(
            currentOpponent: currentOpponent ?? old.currentOpponent,
            boardGame: boardGame ?? old.boardGame,
            indexNextPlayer: old.indexNextPlayer != null
                ? old.indexNextPlayer
                : indexNextPlayer ?? old.indexNextPlayer,
            indexCurrentPlayer: indexCurrentPlayer ?? old.indexCurrentPlayer,
            playerList: playerList ?? old.playerList);

  List<Player> get playerListFromCurrentCell {
    final idCurrentCell = boardGame.cells.indexOf(currentCell);
    return playerListFromCell(idCurrentCell);
  }

  List<Player> playerListFromCell(int idCell) {
    return playerList
        .where((element) => element.idCurrentCell == idCell)
        .toList();
  }

  String get currentCellName =>
      boardGame.cells[playerList[indexCurrentPlayer].idCurrentCell].name;

  Player get currentPlayer => playerList[indexCurrentPlayer];

  Cell get currentCell => boardGame.cells[currentPlayer.idCurrentCell];

  get nextIndexPlayer {
    if (indexNextPlayer != null) {
      final idNextPlayer = indexNextPlayer;
      this.indexNextPlayer = null;
      return idNextPlayer;
    } else if (indexCurrentPlayer == playerList.length - 1) {
      return 0;
    }
    return indexCurrentPlayer + 1;
  }
}
