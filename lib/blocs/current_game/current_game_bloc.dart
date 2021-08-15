import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/blocs/bloc_emitter.dart';
import 'package:ptit_godet/blocs/dice/dice_bloc.dart';
import 'package:ptit_godet/blocs/focused_cell_bloc/focused_cell_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/models/cell.dart';
import 'package:ptit_godet/models/condition_key.dart';
import 'package:ptit_godet/models/moving.dart';
import 'package:ptit_godet/models/player.dart';
import 'package:ptit_godet/pages/finish_game_page.dart';
import 'package:ptit_godet/pages/game_page.dart';

class CurrentGameBloc extends BlocEmitter<CurrentGameEvent, CurrentGameState>
    with SnackBarBloc {
  CurrentGameBloc(
      {required this.navBloc,
      required this.diceBloc,
      required this.focusedCellBloc})
      : _errorController = StreamController<String>.broadcast(),
        super(CurrentGameState.empty());

  final NavBloc navBloc;
  final DiceBloc diceBloc;
  final FocusedCellBloc focusedCellBloc;
  final StreamController<String> _errorController;

  @override
  Future<void> close() {
    _errorController.close();
    return super.close();
  }

  Stream<String> get errorStream => _errorController.stream;

  @override
  Stream<CurrentGameState> mapEventToState(CurrentGameEvent event) async* {
    if (event is InitModelCurrentGame) {
      yield CurrentGameState.copy(state, boardGame: event.boardGame);
    } else if (event is AddPlayer) {
      yield CurrentGameState.copy(state,
          playerList: [...state.playerList, Player.fromGenerator()]);
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
    } else if (event is ResetPlayerGame) {
      yield* _resetPlayerGame(event);
    } else if (event is InitGameAnimationController) {
      yield CurrentGameState.copy(state, controller: event.controller);
    }
  }

  PlayerState _playerStateFromCellType(Cell nextCell, int diceValue) {
    final nextCellType = nextCell.cellType,
        currentPlayer = state.currentPlayer!;
    if (nextCellType == CellType.finish) {
      if (nextCell.diceCondition == diceValue) {
        return PlayerState.winner;
      }
    }
    if (nextCellType == CellType.conditionKey) {
      final requiredConditionKey = nextCell.requiredConditionKey;
      if (requiredConditionKey == null ||
          !currentPlayer.conditionKeyList.contains(requiredConditionKey)) {
        emitRichTextSnackBar(RichText(
            text: TextSpan(children: [
          if (requiredConditionKey != null)
            TextSpan(
                text: currentPlayer.name,
                style: TextStyle(fontWeight: FontWeight.bold)),
          if (requiredConditionKey != null) TextSpan(text: " n'a pas de "),
          if (requiredConditionKey != null)
            TextSpan(
                text: "${requiredConditionKey.name}. ",
                style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(
              text: currentPlayer.name,
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: " retourne à un "),
          TextSpan(
              text: "précédent checkpoint.",
              style: TextStyle(color: Colors.red))
        ])));
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
    } else if (nextCellType == CellType.selfMovingPlayerChose) {
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
        idCurrentCell = currentPlayer!.idCurrentCell,
        idNextCell = _getNextCell(idCurrentCell, diceValue, force),
        trueThrowDice = idNextCell - idCurrentCell;
    var nextCell = state.boardGame!.cells[idNextCell],
        shownDiceValue =
            nextCell.cellType == CellType.jail || trueThrowDice == 0
                ? diceValue
                : trueThrowDice;
    diceBloc.add(ShowDice(shownDiceValue));
    final conditionKeyIf = nextCell.conditionIf,
        ifElseMode = nextCell.cellType == CellType.ifElse
            ? state.currentPlayer!.conditionKeyList.contains(conditionKeyIf)
                ? IfElseMode.ifMode
                : IfElseMode.elseMode
            : IfElseMode.none;
    switch (ifElseMode) {
      case IfElseMode.ifMode:
        nextCell = nextCell.ifCell!;
        emitRichTextSnackBar(RichText(
            text: TextSpan(children: [
          TextSpan(text: "Cette case est à effet conditionnel.\n"),
          TextSpan(
              text: currentPlayer.name,
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: " a "),
          TextSpan(
              text: conditionKeyIf!.name,
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ", les effets de la case correspondent au "),
          TextSpan(text: "SI.", style: TextStyle(color: Colors.green)),
        ])));
        break;
      case IfElseMode.elseMode:
        nextCell = nextCell.elseCell!;
        emitRichTextSnackBar(RichText(
            text: TextSpan(children: [
          TextSpan(text: "Cette case est à effet conditionnel.\n"),
          TextSpan(
              text: currentPlayer.name,
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: " n'a pas de "),
          TextSpan(
              text: conditionKeyIf!.name,
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ", les effets de la case correspondent au "),
          TextSpan(text: "SINON.", style: TextStyle(color: Colors.red)),
        ])));
        break;
      default:
        nextCell = nextCell;
        break;
    }
    final nextPlayerState = _playerStateFromCellType(nextCell, diceValue),
        conditionKeyList = _getConditionKeyList(
            nextPlayerState, currentPlayer.conditionKeyList, nextCell),
        actualCell = nextCell.actualCell(ifElseMode)!,
        drinkMap = _playerDrinkMap(actualCell, currentPlayer);

    var playerList = state.playerList.map((player) {
      if (player == currentPlayer) {
        final actualCell = state.actualCell,
            inPrison = actualCell!.cellType == CellType.jail;
        return Player.copy(player,
            drinkMap: drinkMap,
            jailTurnCount:
                inPrison && trueThrowDice == 0 ? player.jailTurnCount + 1 : 0,
            ifElseMode: ifElseMode,
            idCurrentCell: idNextCell,
            state: nextPlayerState,
            conditionKeyList: conditionKeyList,
            lastDiceValue: shownDiceValue);
      }
      return player;
    }).toList();

    final everybodyDrinkCount = actualCell.sideEffectList
        .where(
            (element) => element.toLowerCase().contains("tout le monde boit"))
        .length;
    if (everybodyDrinkCount > 0)
      playerList = playerList
          .map((e) => Player.addSips(e, sipsCount: everybodyDrinkCount))
          .toList();
    if (nextPlayerState == PlayerState.winner) {
      yield CurrentGameState.copy(state,
          playerList: playerList, winner: currentPlayer);
      state.controller!.reverse().then((value) => navBloc
          .add(ResetNav(pageBuilder: (dynamic) => const FinishGamePage())));
    } else {
      yield CurrentGameState.copy(state, playerList: playerList);
    }
  }

  Stream<CurrentGameState> _changeNamePlayer(ChangeNamePlayer event) async* {
    final playerList = state.playerList.map((player) {
      if (player.id == event.player.id) {
        return Player.copy(player, name: event.name);
      }
      return player;
    }).toList();
    yield CurrentGameState.copy(state, playerList: playerList);
  }

  Stream<CurrentGameState> _validateGame(ValidateGame event) async* {
    final playerListOnCurrentCell = state.playerListFromCurrentCell;
    if (playerListOnCurrentCell.isNotEmpty) {
      focusedCellBloc.add(ChangeFocusedPlayer(playerListOnCurrentCell[0]));
    }

    final playerList = state.playerList,
        areAllPlayerNameDifferent = playerList
            .fold<Map<String, int>>({}, (map, element) {
              final name = element.name;
              if (map.containsKey(name)) {
                final value = map[name]!;
                map[name] = value + 1;
              } else {
                map[name] = 1;
              }
              return map;
            })
            .values
            .every((element) => element == 1);
    if (playerList.length < 2) {
      _errorController
          .add("Il doit y avoir au moins 2 joueurs pour lancer une partie.");
    } else if (playerList.every((element) => element.name.isNotEmpty) &&
        areAllPlayerNameDifferent) {
      event.animationCallback().then((value) => navBloc.add(
          PushNav(pageBuilder: (_) => const GamePage(), onPop: event.onPop)));
    } else {
      _errorController
          .add("Tous les pseudos doivent être saisis et différents.");
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
        playerList: playerList,
        indexCurrentPlayer: state.nextIndexPlayer,
        indexNextPlayer: -1);
  }

  int _getNextCell(int idCurrentCell, int diceValue, bool force) {
    if (force) {
      return idCurrentCell + diceValue;
    }
    if (state.boardGame!.cells[idCurrentCell].cellType == CellType.finish) {
      return idCurrentCell;
    }
    final actualCell = state.actualCell,
        inPrison = actualCell!.cellType == CellType.jail,
        currentPlayer = state.currentPlayer!;
    if ((inPrison &&
            !actualCell.jailCondition!.dicePossibilities.contains(diceValue) &&
            currentPlayer.jailTurnCount < 3) ||
        (currentPlayer.state != PlayerState.ready &&
            actualCell.cellType == CellType.selfThrowDice &&
            currentPlayer.state != PlayerState.thrownDice)) {
      return idCurrentCell;
    }
    for (var i = idCurrentCell + 1; i < idCurrentCell + diceValue; i++) {
      final cell = state.boardGame!.cells[i];
      if ((cell.cellType == CellType.conditionKey && cell.tpCell == null) ||
          cell.cellType == CellType.finish) {
        return i;
      }
    }
    return idCurrentCell + diceValue;
  }

  Stream<CurrentGameState> _returnPreviousCheckpoint() async* {
    final tpCell = state.actualCell!.tpCell;
    var idTpCell;
    if (tpCell != null) {
      idTpCell = state.boardGame!.cells
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
      final cell = state.boardGame!.cells[i];
      if (cell.cellType == CellType.conditionKey && cell.tpCell == null) {
        return i;
      }
    }
    return 0;
  }

  Stream<CurrentGameState> _movePlayer() async* {
    final moving = state.actualCell!.moving, count = moving!.count;
    yield* _throwDice(moving.movingType == MovingType.forward ? count : -count);
  }

  Stream<CurrentGameState> _movingForward() async* {
    final movingUndeterminedCount = state.actualCell!.movingUndeterminedCount;
    yield* _throwDice(movingUndeterminedCount!);
  }

  Stream<CurrentGameState> _moveBack() async* {
    final movingUndeterminedCount = state.actualCell!.movingUndeterminedCount;
    yield* _throwDice(-movingUndeterminedCount!);
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
              state.actualCell!.givenConditionKey!,
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
        ].contains(playerState) &&
        givenConditionKey != null) {
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
                        state.actualCell!.givenConditionKey!,
                        ...player.conditionKeyList
                      ]
                    : player.conditionKeyList);
          } else if (playerElem == player) {
            return Player.copy(player, conditionKeyList: [
              state.actualCell!.givenConditionKey!,
              ...player.conditionKeyList
            ]);
          }
          return playerElem;
        }).toList(),
        indexCurrentPlayer: state.nextIndexPlayer,
        indexNextPlayer: -1);
  }

  Stream<CurrentGameState> _makePlayerMoving(Player player) async* {
    final actualCell = state.actualCell,
        moving = actualCell!.moving!,
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
    final conditionKey = state.actualCell!.conditionKeyStolen!;
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
        indexCurrentPlayer: state.nextIndexPlayer,
        indexNextPlayer: -1);
  }

  Stream<CurrentGameState> _resetGame() async* {
    yield CurrentGameState.empty();
  }

  Stream<CurrentGameState> _removePlayer(Player player) async* {
    yield CurrentGameState.copy(state,
        playerList: state.playerList
            .where((element) => element.id != player.id)
            .toList());
  }

  Stream<CurrentGameState> _changePicturePlayer(
      ChangePicturePlayer event) async* {
    final player = event.player;
    yield CurrentGameState.copy(state,
        playerList: state.playerList.map((e) {
          if (e.id == player.id) {
            return Player.copy(e, avatar: event.pictureData);
          }
          return e;
        }).toList());
  }

  Stream<CurrentGameState> _resetPlayerGame(ResetPlayerGame event) async* {
    final boardGame = state.boardGame;
    yield CurrentGameState.copy(CurrentGameState.empty(), boardGame: boardGame);
  }

  Map<DrinkType, int> _playerDrinkMap(Cell nextCell, Player currentPlayer) {
    final drinkMap = currentPlayer.drinkMap,
        effectsLabel = nextCell.sideEffectList,
        effectsAfterLabel = nextCell.sideEffectListAfterTurnLost,
        youDrinkLabels = [...effectsLabel, ...effectsAfterLabel]
            .map((e) => e.toLowerCase())
            .where((element) => element.contains("bois")),
        sipsLabels = youDrinkLabels
            .where((element) =>
                !element.contains(DrinkType.cemetery.extractedLabel) &&
                !element.contains(DrinkType.oneGulp.extractedLabel) &&
                !element.contains(DrinkType.shot.extractedLabel))
            .map((e) {
          final labelWithOnlyNumbers = e.replaceAll(RegExp('[^0-9]'), '');
          if (labelWithOnlyNumbers.isEmpty) return 1;
          return int.parse(labelWithOnlyNumbers);
        });
    return {
      DrinkType.sips: drinkMap[DrinkType.sips]! +
          (sipsLabels.isNotEmpty
              ? sipsLabels.reduce((value, element) => value + element)
              : 0),
      DrinkType.cemetery: drinkMap[DrinkType.cemetery]! +
          youDrinkLabels
              .where((element) =>
                  element.contains(DrinkType.cemetery.extractedLabel))
              .length,
      DrinkType.oneGulp: drinkMap[DrinkType.oneGulp]! +
          youDrinkLabels
              .where((element) =>
                  element.contains(DrinkType.oneGulp.extractedLabel))
              .length,
      DrinkType.shot: drinkMap[DrinkType.shot]! +
          youDrinkLabels
              .where(
                  (element) => element.contains(DrinkType.shot.extractedLabel))
              .length
    };
  }
}

abstract class CurrentGameEvent extends Equatable {
  const CurrentGameEvent();

  @override
  List<Object> get props => [];
}

class InitGameAnimationController extends CurrentGameEvent {
  const InitGameAnimationController(this.controller);

  final AnimationController controller;
}

class InitModelCurrentGame extends CurrentGameEvent {
  final BoardGame boardGame;

  const InitModelCurrentGame({required this.boardGame});
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
  final int? value;

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

  const ChangeNamePlayer({required this.player, required this.name});

  @override
  List<Object> get props => [player, name];
}

class ChangePicturePlayer extends CurrentGameEvent {
  final Player player;
  final Uint8List pictureData;

  ChangePicturePlayer({required this.player, required this.pictureData});
}

class ValidateGame extends CurrentGameEvent {
  const ValidateGame({required this.onPop, required this.animationCallback});

  final VoidCallback onPop;
  final TickerFuture Function() animationCallback;
}

class ResetPlayerGame extends CurrentGameEvent {
  const ResetPlayerGame();
}

class CurrentGameState extends Equatable {
  CurrentGameState(
      {this.boardGame,
      this.playerList = const [],
      this.indexNextPlayer = 1,
      this.indexCurrentPlayer = 0,
      this.currentOpponent,
      this.winner,
      this.controller});

  final BoardGame? boardGame;
  final List<Player> playerList;
  final int indexCurrentPlayer;
  final int? indexNextPlayer;
  final Player? currentOpponent;
  final Player? winner;
  final AnimationController? controller;

  CurrentGameState.empty()
      : this(playerList: List.generate(2, (_) => Player.fromGenerator()));

  bool get isFinish => winner != null;

  @override
  List<Object?> get props => [
        boardGame,
        playerList,
        indexCurrentPlayer,
        currentOpponent,
        winner,
        controller
      ];

  CurrentGameState.copy(CurrentGameState old,
      {BoardGame? boardGame,
      List<Player>? playerList,
      Player? currentOpponent,
      int? indexNextPlayer,
      int? indexCurrentPlayer,
      Player? winner,
      AnimationController? controller})
      : this(
            winner: winner ?? old.winner,
            currentOpponent: currentOpponent ?? old.currentOpponent,
            boardGame: boardGame ?? old.boardGame,
            indexNextPlayer: indexNextPlayer == -1
                ? null
                : old.indexNextPlayer != null
                    ? old.indexNextPlayer
                    : indexNextPlayer ?? old.indexNextPlayer,
            indexCurrentPlayer: indexCurrentPlayer ?? old.indexCurrentPlayer,
            playerList: playerList ?? old.playerList,
            controller: controller ?? old.controller);

  List<Player> get playerListFromCurrentCell {
    final idCurrentCell = boardGame!.cells.indexOf(currentCell!);
    return playerListFromIdCell(idCurrentCell);
  }

  bool get isEmpty => playerList.every((element) => element.idCurrentCell == 0);

  List<Player> get playerListInWinOrder => [...playerList]..sort();

  List<Player> playerListFromIdCell(int idCell) {
    return playerList
        .where((element) => element.idCurrentCell == idCell)
        .toList();
  }

  List<Player> playerListFromCell(Cell cell) {
    final idCell = boardGame!.cells.indexOf(cell);
    return playerListFromIdCell(idCell);
  }

  String get currentCellName =>
      boardGame!.cells[playerList[indexCurrentPlayer].idCurrentCell].name;

  Player? get currentPlayer {
    if (playerList.length > indexCurrentPlayer)
      return playerList[indexCurrentPlayer];
  }

  Cell? get currentCell {
    if (currentPlayer != null) {
      final cells = boardGame!.cells,
          idCurrentCell = currentPlayer!.idCurrentCell;
      if (cells.length > idCurrentCell) {
        return cells[idCurrentCell];
      }
    }
    return null;
  }

  Cell? get actualCell => currentCell!.actualCell(currentPlayer!.ifElseMode);

  get nextIndexPlayer {
    if (indexNextPlayer != null) {
      return indexNextPlayer;
    } else if (indexCurrentPlayer == playerList.length - 1) {
      return 0;
    }
    return indexCurrentPlayer + 1;
  }

  List<Player> playerListAbleToMove() {
    final moving = currentCell!.moving!,
        movingCount = moving.movingType == MovingType.forward
            ? moving.count
            : -moving.count;
    return playerList
        .where((element) =>
            currentPlayer != element &&
            (element.idCurrentCell + movingCount) > 0 &&
            (element.idCurrentCell + movingCount) < boardGame!.cells.length)
        .toList();
  }

  List<Player> playerListAbleToBeStolen() {
    final conditionKey = actualCell!.conditionKeyStolen;
    return playerList
        .where((element) =>
            element != currentPlayer &&
            element.conditionKeyList.contains(conditionKey))
        .toList();
  }

  @override
  String toString() {
    return 'CurrentGameState{boardGame: $boardGame, playerList: $playerList, indexCurrentPlayer: $indexCurrentPlayer, indexNextPlayer: $indexNextPlayer, currentOpponent: $currentOpponent, winner: $winner}';
  }

  ///
  /// Give the next conditionKey or the ifConditionKey if [idCurrentCell]
  /// is exactly at a ifElse cell.
  ///
  ConditionKey? nextConditionKey(int idCurrentCell) {
    final cells = boardGame!.cells;
    var cell = cells[idCurrentCell];
    if (cell.cellType == CellType.ifElse) return cell.conditionIf;
    cell = cells.sublist(idCurrentCell).firstWhere(
        (element) => element.requiredConditionKey != null,
        orElse: () => Cell.nullable());
    if (cell != Cell.nullable()) return cell.requiredConditionKey!;
  }
}
