import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/dice/dice_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/models/cell.dart';
import 'package:ptit_godet/models/condition_key.dart';
import 'package:ptit_godet/models/moving.dart';
import 'package:ptit_godet/models/player.dart';

class NavBlocMock extends Mock implements NavBloc {}

class DiceBlocMock extends Mock implements DiceBloc {}

void main() {
  BoardGame _initBoardGame = BoardGame(name: "Jeux de l'oie", cells: [
    Cell(name: "Rentrée", imgPath: "", sideEffectList: ["C'est la rentrée !"]),
    Cell(
        cellType: CellType.selfMoving,
        moving: Moving(count: 2, movingType: MovingType.forward),
        name: "Polypoint",
        imgPath: "",
        givenConditionKey: ConditionKey(name: "Polypoint")),
    Cell(
        name: "4a",
        imgPath: "",
        cellType: CellType.conditionKey,
        givenConditionKey: ConditionKey(name: "Polypoint"),
        requiredConditionKey: ConditionKey(name: "Polypoint")),
    Cell(
        name: "Intégration BDSM",
        imgPath: "",
        givenConditionKey: ConditionKey(name: "BDSM")),
    Cell(
        name: "5A",
        imgPath: "",
        cellType: CellType.conditionKey,
        sideEffectList: ["Tu bois"],
        requiredConditionKey: ConditionKey(name: "UE"))
  ]);

  CurrentGameState _initState = CurrentGameState(playerList: [
    Player(
        conditionKeyList: [ConditionKey(name: "Polypoint")],
        state: PlayerState.ready,
        name: "Alexis",
        id: 0,
        idCurrentCell: 3)
  ], boardGame: _initBoardGame, indexCurrentPlayer: 0, indexNextPlayer: 0);

  CurrentGameBloc _createBloc() {
    // ignore: close_sinks
    final navBloc = NavBlocMock(), diceBloc = DiceBlocMock();
    return CurrentGameBloc(navBloc: navBloc, diceBloc: diceBloc);
  }

  group("CurrentGameBloc tests", () {
    blocTest<CurrentGameBloc, CurrentGameState>(
        "On rolling dice reach 5a cell without UE, player should be in return previousCheckPoint state.",
        build: () {
          final bloc = _createBloc();
          bloc.emit(_initState);
          return bloc;
        },
        act: (cubit) => cubit.add(ThrowDice(1)),
        expect: [
          CurrentGameState.copy(_initState, playerList: [
            Player(
                conditionKeyList: [ConditionKey(name: "Polypoint")],
                state: PlayerState.returnPreviousCheckPoint,
                name: "Alexis",
                id: 0,
                idCurrentCell: 4)
          ])
        ]);

    blocTest<CurrentGameBloc, CurrentGameState>(
        "On rolling dice reach 5a cell without UE, player should go back to 4a.",
        build: () {
          final bloc = _createBloc();
          bloc.emit(CurrentGameState.copy(_initState, playerList: [
            Player(
                conditionKeyList: [ConditionKey(name: "Polypoint")],
                state: PlayerState.returnPreviousCheckPoint,
                name: "Alexis",
                id: 0,
                idCurrentCell: 4)
          ]));
          return bloc;
        },
        act: (cubit) => cubit.add(ReturnPreviousCheckpoint()),
        expect: [
          CurrentGameState.copy(_initState, playerList: [
            Player(
                conditionKeyList: [ConditionKey(name: "Polypoint")],
                state: PlayerState.canEnd,
                name: "Alexis",
                id: 0,
                idCurrentCell: 2)
          ])
        ]);
  });
}
