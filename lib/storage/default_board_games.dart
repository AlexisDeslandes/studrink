import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/models/cell.dart';
import 'package:ptit_godet/models/condition_key.dart';
import 'package:ptit_godet/models/moving.dart';
import 'package:ptit_godet/models/prison_condition.dart';
import 'package:ptit_godet/models/throw_dice_effect.dart';

class DefaultBoardGames {
  static const DefaultBoardGames _instance = DefaultBoardGames._();

  factory DefaultBoardGames() => _instance;

  const DefaultBoardGames._();

  List<BoardGame> boardGameList() {
    return [
      BoardGame(
        imgUrl: "assets/icons/goose.svg",
          name: "Jeu de l'oie",
          cells: [
            Cell(
                name: "Rentrée",
                imgPath: "",
                sideEffectList: ["C'est la rentrée !"]),
            Cell(
                cellType: CellType.selfMoving,
                moving: Moving(count: 2, movingType: MovingType.forward),
                name: "Polypoint",
                imgPath: "",
                givenConditionKey: ConditionKey(name: "Polypoint")),
            Cell(
                name: "BressomLand",
                imgPath: "",
                sideEffectList: ["Ca part en cul sec."]),
            Cell(name: "Clausse", imgPath: "", sideEffectList: ["Tu bois."]),
            Cell(
                name: "WEC1",
                imgPath: "",
                sideEffectList: ["Tu bois"],
                sideEffectListAfterTurnLost: ["Tu bois"],
                cellType: CellType.turnLose),
            Cell(
                name: "Parking",
                imgPath: "",
                sideEffectList: ["Invente ta propre règle."]),
            Cell(
                name: "Partiel",
                imgPath: "",
                cellType: CellType.prison,
                prisonCondition: PrisonCondition([3, 4]),
                sideEffectList: ["Plus le droit de boire."]),
            Cell(
                name: "Balais-couille",
                imgPath: "",
                cellType: CellType.selfThrowDice,
                throwDiceEffect:
                    ThrowDiceEffect(sideEffect: "Bois sa valeur.")),
            Cell(
                name: "Polypoint",
                imgPath: "",
                cellType: CellType.selfChallenge,
                challenge: "Bois un cul sec.",
                givenConditionKey: ConditionKey(name: "Polypoint")),
            Cell(
                name: "Sodomie",
                imgPath: "",
                cellType: CellType.selfMovingUndetermined,
                movingUndeterminedCount: 1),
            Cell(
                name: "Depardieu",
                imgPath: "",
                sideEffectList: ["Tout le monde boit."]),
            Cell(
                name: "4a",
                imgPath: "",
                cellType: CellType.conditionKey,
                givenConditionKey: ConditionKey(name: "Polypoint"),
                requiredConditionKey: ConditionKey(name: "Polypoint")),
            Cell(
                name: "Otrak",
                imgPath: "",
                sideEffectList: ["Bois un cimetière."]),
            Cell(
                name: "Intégration BDSM",
                imgPath: "",
                givenConditionKey: ConditionKey(name: "BDSM")),
            Cell(
                name: "Shi Fu Cuite",
                imgPath: "",
                cellType: CellType.battle,
                givenConditionKey: ConditionKey(name: "UE")),
            Cell(
                name: "Parking",
                imgPath: "",
                cellType: CellType.otherMoving,
                moving: Moving(count: 1, movingType: MovingType.forward)),
            Cell(name: "WEC2", imgPath: "", sideEffectList: [
              "Bois un cul sec.",
              "Embrasse le plus bourré."
            ]),
            Cell(
                name: "Nazgûl",
                imgPath: "",
                cellType: CellType.otherMoving,
                moving: Moving(movingType: MovingType.backward, count: 1)),
            Cell(
                name: "Juif",
                imgPath: "",
                cellType: CellType.selfChallenge,
                challenge: "Les autres te lancent un défis.",
                givenConditionKey: ConditionKey(name: "UE")),
            Cell(name: "Ski", imgPath: "", sideEffectList: ["Bois 3 gorgées."]),
            Cell(name: "KO", imgPath: "", cellType: CellType.turnLose),
            Cell(
                name: "FIST",
                imgPath: "",
                cellType: CellType.selfMoving,
                moving: Moving(movingType: MovingType.backward, count: 2)),
            Cell(
                name: "Noir",
                imgPath: "",
                cellType: CellType.steal,
                conditionKeyStolen: ConditionKey(name: "UE")),
            Cell(
                name: "5A",
                imgPath: "",
                cellType: CellType.conditionKey,
                sideEffectList: ["Tu bois"],
                requiredConditionKey: ConditionKey(name: "UE")),
            Cell(
                name: "BDSM",
                givenConditionKey: ConditionKey(name: "BDSM"),
                imgPath: ""),
            Cell(
                name: "WEC3",
                sideEffectList: ["Donne 2 gorgées."],
                imgPath: ""),
            Cell(name: "MNM'S", imgPath: "", sideEffectList: [
              "Désigne un joueur.",
              "Le joueur boit le nombre de gorgées et désigne un joueur qui les boit également."
            ]),
            Cell(
                imgPath: "",
                name: "QPUC Stage",
                cellType: CellType.selfChallenge,
                givenConditionKey: ConditionKey(name: "Stage"),
                challenge: "Un autre joueur te pose une question."),
            Cell(
                imgPath: "", name: "ABEL", sideEffectList: ["Bois 4 gorgées."]),
            Cell(
                cellType: CellType.ifElse,
                conditionIf: ConditionKey(name: "BDSM"),
                elseCell: Cell(
                    imgPath: "",
                    name: "",
                    cellType: CellType.selfMoving,
                    moving: Moving(count: 1, movingType: MovingType.backward),
                    lostConditionKey: ConditionKey(name: "Stage"),
                    givenConditionKey: ConditionKey(name: "BDSM")),
                ifCell: Cell(
                    name: "",
                    imgPath: "",
                    cellType: CellType.noEffect,
                    sideEffectList: ["Donne un cul sec"]),
                imgPath: "",
                name: "BDSM"),
            Cell(
                imgPath: "",
                name: "BEACH",
                sideEffectList: ["Prends un shot + sexe"]),
            Cell(
                name: "Blackout",
                imgPath: "",
                cellType: CellType.conditionKey,
                tpCell: Cell(
                    name: "4a",
                    imgPath: "",
                    cellType: CellType.conditionKey,
                    givenConditionKey: ConditionKey(name: "Polypoint"),
                    requiredConditionKey: ConditionKey(name: "Polypoint"))),
            Cell(
                name: "Stage",
                imgPath: "",
                givenConditionKey: ConditionKey(name: "Stage")),
            Cell(
                name: "Diplôme",
                imgPath: "",
                cellType: CellType.conditionKey,
                requiredConditionKey: ConditionKey(name: "Stage")),
            Cell(
                name: "Embauche",
                imgPath: "",
                sideEffectList: [
                  "Tu bois la différence.",
                  "Tout le monde finira son verre pour fêter l'embauche."
                ],
                cellType: CellType.finish,
                diceCondition: 6)
          ],
          date: DateTime.now())
    ];
  }
}
