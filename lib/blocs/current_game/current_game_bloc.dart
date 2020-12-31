import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/dice/dice_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/models/cell.dart';
import 'package:ptit_godet/models/condition_key.dart';
import 'package:ptit_godet/models/moving.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/pages/finish_game_page.dart';
import 'package:ptit_godet/pages/game_page.dart';

class CurrentGameBloc extends Bloc<CurrentGameEvent, CurrentGameState> {
  final NavBloc navBloc;
  final DiceBloc diceBloc;
  final StreamController<String> _errorController;

  CurrentGameBloc({@required this.navBloc, @required this.diceBloc})
      : assert(navBloc != null && diceBloc != null),
        _errorController = StreamController<String>.broadcast(),
        super(CurrentGameState.empty());

  Stream<String> get errorStream => _errorController.stream;

  @override
  Future<void> close() {
    _errorController.close();
    return super.close();
  }

  @override
  Stream<CurrentGameState> mapEventToState(CurrentGameEvent event) async* {
    if (event is InitModelCurrentGame) {
      yield CurrentGameState.copy(state, boardGame: event.boardGame);
    } else if (event is AddPlayer) {
      yield CurrentGameState.copy(state,
          playerList: [...state.playerList, Player()]);
    } else if (event is ChangeNamePlayer) {
      yield* _changeNamePlayer(event);
    } else if (event is ValidateGame) {
      yield* _validateGame(event);
    } else if (event is ThrowDice) {
      final random = Random(), diceValue = random.nextInt(6) + 1;
      yield* _throwDice(event.value ?? diceValue);
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
    } else if (event is ResetGame) {
      yield* _resetGame();
    } else if (event is RemovePlayer) {
      yield* _removePlayer(event.player);
    } else if (event is ChangePicturePlayer) {
      yield* _changePicturePlayer(event);
    }
  }

  PlayerState _playerStateFromCellType(Cell nextCell, int diceValue) {
    final nextCellType = nextCell.cellType, currentPlayer = state.currentPlayer;
    if (nextCellType == CellType.finish) {
      if (nextCell.diceCondition == diceValue) {
        return PlayerState.winner;
      }
    }
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
        idCurrentCell = currentPlayer.idCurrentCell,
        idNextCell = _getNextCell(idCurrentCell, diceValue, force),
        trueThrowDice = idNextCell - idCurrentCell;
    var nextCell = state.boardGame.cells[idNextCell];
    diceBloc.add((nextCell.cellType == CellType.prison || trueThrowDice == 0)
        ? ShowDice(diceValue)
        : ShowDice(trueThrowDice));
    final ifElseMode = nextCell.cellType == CellType.ifElse
        ? state.currentPlayer.conditionKeyList.contains(nextCell.conditionIf)
            ? IfElseMode.ifMode
            : IfElseMode.elseMode
        : IfElseMode.none;
    switch (ifElseMode) {
      case IfElseMode.ifMode:
        nextCell = nextCell.ifCell;
        break;
      case IfElseMode.elseMode:
        nextCell = nextCell.elseCell;
        break;
      default:
        nextCell = nextCell;
        break;
    }
    final nextPlayerState = _playerStateFromCellType(nextCell, diceValue),
        conditionKeyList = _getConditionKeyList(
            nextPlayerState, currentPlayer.conditionKeyList, nextCell);

    final playerList = state.playerList.map((player) {
      if (player == currentPlayer) {
        return Player.copy(player,
            ifElseMode: ifElseMode,
            idCurrentCell: idNextCell,
            state: nextPlayerState,
            conditionKeyList: conditionKeyList);
      }
      return player;
    }).toList();

    if (nextPlayerState == PlayerState.winner) {
      yield CurrentGameState.copy(state,
          playerList: playerList, winner: currentPlayer);
      navBloc.add(PushNav(pageBuilder: (dynamic) => const FinishGamePage()));
    } else {
      yield CurrentGameState.copy(state, playerList: playerList);
    }
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
    if (state.playerList.length < 2) {
      _errorController
          .add("Il doit y avoir au moins 2 joueurs pour lancer une partie.");
    } else if (state.playerList.every((element) => element.filled)) {
      navBloc.add(PushNav(pageBuilder: (_) => const GamePage()));
    } else {
      _errorController.add("Tous les pseudos n'ont pas été saisis.");
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
    if (state.boardGame.cells[idCurrentCell].cellType == CellType.finish) {
      return idCurrentCell;
    }
    final actualCell = state.actualCell,
        inPrison = actualCell.cellType == CellType.prison;
    if ((inPrison &&
            !actualCell.prisonCondition.dicePossibilities
                .contains(diceValue)) ||
        (state.currentPlayer.state != PlayerState.ready &&
            actualCell.cellType == CellType.selfThrowDice &&
            state.currentPlayer.state != PlayerState.thrownDice)) {
      return idCurrentCell;
    }
    for (var i = idCurrentCell + 1; i < idCurrentCell + diceValue; i++) {
      final cell = state.boardGame.cells[i];
      if ((cell.cellType == CellType.conditionKey && cell.tpCell == null) ||
          cell.cellType == CellType.finish) {
        return i;
      }
    }
    return idCurrentCell + diceValue;
  }

  Stream<CurrentGameState> _returnPreviousCheckpoint() async* {
    final tpCell = state.actualCell.tpCell;
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
      final cell = state.boardGame.cells[i];
      if (cell.cellType == CellType.conditionKey && cell.tpCell == null) {
        return i;
      }
    }
    return 0;
  }

  Stream<CurrentGameState> _movePlayer() async* {
    final moving = state.actualCell.moving, count = moving.count;
    yield* _throwDice(moving.movingType == MovingType.forward ? count : -count);
  }

  Stream<CurrentGameState> _movingForward() async* {
    final movingUndeterminedCount = state.actualCell.movingUndeterminedCount;
    yield* _throwDice(movingUndeterminedCount);
  }

  Stream<CurrentGameState> _moveBack() async* {
    final movingUndeterminedCount = state.actualCell.movingUndeterminedCount;
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
              state.actualCell.givenConditionKey,
              ...player.conditionKeyList
            ]);
      }
      return player;
    }).toList();
    yield CurrentGameState.copy(state, playerList: playerList);
  }

  List<ConditionKey> _getConditionKeyList(
      PlayerState playerState, List<ConditionKey> currentList, Cell nextCell) {
    final givenConditionKey = nextCell.givenConditionKey,
        lostConditionKey = nextCell.lostConditionKey;
    List<ConditionKey> result;
    if ([
      PlayerState.canEnd,
      PlayerState.moving,
      PlayerState.returnPreviousCheckPoint
    ].contains(playerState)) {
      result = [givenConditionKey, ...currentList];
    } else {
      result = [...currentList];
    }
    return result.where((element) => element != lostConditionKey).toList();
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
                        state.actualCell.givenConditionKey,
                        ...player.conditionKeyList
                      ]
                    : player.conditionKeyList);
          } else if (playerElem == player) {
            return Player.copy(player, conditionKeyList: [
              state.actualCell.givenConditionKey,
              ...player.conditionKeyList
            ]);
          }
          return playerElem;
        }).toList(),
        indexCurrentPlayer: state.nextIndexPlayer);
  }

  Stream<CurrentGameState> _makePlayerMoving(Player player) async* {
    final actualCell = state.actualCell,
        moving = actualCell.moving,
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
    final conditionKey = state.actualCell.conditionKeyStolen;
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

  Stream<CurrentGameState> _resetGame() async* {
    yield CurrentGameState.empty();
  }

  Stream<CurrentGameState> _removePlayer(Player player) async* {
    yield CurrentGameState.copy(state,
        playerList:
            state.playerList.where((element) => element != player).toList());
  }

  Stream<CurrentGameState> _changePicturePlayer(
      ChangePicturePlayer event) async* {
    final player = event.player;
    yield CurrentGameState.copy(state,
        playerList: state.playerList.map((e) {
          if (e == player) {
            return Player.copy(e, avatar: event.pictureData);
          }
          return e;
        }).toList());
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
  final int value;

  const ThrowDice([this.value]);
}

class ResetGame extends CurrentGameEvent {
  const ResetGame();
}

class ReturnPreviousCheckpoint extends CurrentGameEvent {
  const ReturnPreviousCheckpoint();
}

class SwitchToOtherPlayer extends CurrentGameEvent {
  const SwitchToOtherPlayer();
}

class RemovePlayer extends CurrentGameEvent {
  final Player player;

  const RemovePlayer(this.player);
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

class ChangePicturePlayer extends CurrentGameEvent {
  final Player player;
  final Uint8List pictureData;

  ChangePicturePlayer({@required this.player, @required this.pictureData});
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
  final Player winner;

  CurrentGameState(
      {this.boardGame,
      this.playerList = const [],
      this.indexNextPlayer,
      this.currentOpponent,
      this.winner,
      this.indexCurrentPlayer = 0});

  CurrentGameState.empty() : this(playerList: [Player(name: "Pseudo")]);

  bool get isFinish => winner != null;

  @override
  List<Object> get props =>
      [boardGame, playerList, indexCurrentPlayer, currentOpponent, winner];

  CurrentGameState.copy(CurrentGameState old,
      {BoardGame boardGame,
      List<Player> playerList,
      Player currentOpponent,
      int indexNextPlayer,
      int indexCurrentPlayer,
      Player winner})
      : this(
            winner: winner ?? old.winner,
            currentOpponent: currentOpponent ?? old.currentOpponent,
            boardGame: boardGame ?? old.boardGame,
            indexNextPlayer: old.indexNextPlayer != null
                ? old.indexNextPlayer
                : indexNextPlayer ?? old.indexNextPlayer,
            indexCurrentPlayer: indexCurrentPlayer ?? old.indexCurrentPlayer,
            playerList: playerList ?? old.playerList);

  List<Player> get playerListFromCurrentCell {
    final idCurrentCell = boardGame.cells.indexOf(currentCell);
    return playerListFromIdCell(idCurrentCell);
  }

  List<Player> playerListFromIdCell(int idCell) {
    return playerList
        .where((element) => element.idCurrentCell == idCell)
        .toList();
  }

  List<Player> playerListFromCell(Cell cell) {
    final idCell = boardGame.cells.indexOf(cell);
    return playerListFromIdCell(idCell);
  }

  String get currentCellName =>
      boardGame.cells[playerList[indexCurrentPlayer].idCurrentCell].name;

  Player get currentPlayer => playerList[indexCurrentPlayer];

  Cell get currentCell => boardGame.cells[currentPlayer.idCurrentCell];

  Cell get actualCell {
    final ifElseMode = currentPlayer.ifElseMode;
    return ifElseMode == IfElseMode.ifMode
        ? currentCell.ifCell
        : ifElseMode == IfElseMode.elseMode
            ? currentCell.elseCell
            : currentCell;
  }

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

  @override
  String toString() {
    return 'CurrentGameState{boardGame: $boardGame, playerList: $playerList, indexCurrentPlayer: $indexCurrentPlayer, indexNextPlayer: $indexNextPlayer, currentOpponent: $currentOpponent, winner: $winner}';
  }
}
