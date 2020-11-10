import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/models/condition_key.dart';
import 'package:ptit_godet/models/moving.dart';
import 'package:ptit_godet/models/prison_condition.dart';
import 'package:ptit_godet/models/resource.dart';
import 'package:ptit_godet/models/throw_dice_effect.dart';

enum CellType {
  noEffect,
  conditionKey,
  selfMoving,
  otherMoving,
  turnLose,
  prison,
  selfThrowDice,
  selfChallenge,
  selfMovingUndetermined,
  battle,
  steal,
  ifElse,
  multiEffect,
  conditionKeyLost
}

class Cell extends Resource {
  final String name;
  final String imgPath;
  final List<String> sideEffectList;
  final List<String> sideEffectListAfterTurnLost;
  final ConditionKey givenConditionKey;
  final ConditionKey requiredConditionKey;
  final ConditionKey conditionKeyStolen;
  final CellType cellType;
  final PrisonCondition prisonCondition;
  final Moving moving;
  final ThrowDiceEffect throwDiceEffect;
  final String challenge;
  final int movingUndeterminedCount;
  final Cell tpCell;
  final Cell ifCell;
  final Cell elseCell;
  final ConditionKey conditionIf;
  final List<CellType> cellTypes;
  final ConditionKey lostConditionKey;

  Cell(
      {@required this.name,
      @required this.imgPath,
      this.movingUndeterminedCount,
      this.givenConditionKey,
      this.prisonCondition,
      this.throwDiceEffect,
      this.moving,
      this.requiredConditionKey,
      this.sideEffectList = const [],
      this.sideEffectListAfterTurnLost = const [],
      this.cellType = CellType.noEffect,
      this.challenge,
      this.conditionKeyStolen,
      this.lostConditionKey,
      this.tpCell,
      this.conditionIf,
      this.ifCell,
      this.cellTypes,
      this.elseCell})
      : assert(name != null && imgPath != null);

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "tpCell": tpCell?.toJson(),
      "conditionKeyStolen": conditionKeyStolen?.toJson(),
      "movingUndeterminedCount": movingUndeterminedCount,
      "challenge": challenge,
      "throwDiceEffect": throwDiceEffect?.toJson(),
      "imgPath": imgPath,
      "prisonCondition": prisonCondition?.toJson(),
      "moving": moving?.toJson(),
      "sideEffectList": sideEffectList,
      "sideEffectListAfterTurnLost": sideEffectListAfterTurnLost,
      "conditionKey": givenConditionKey?.toJson(),
      "requiredConditionKey": requiredConditionKey?.toJson(),
      "cellType": cellType.index,
      "ifCell": ifCell?.toJson(),
      "conditionIf": conditionIf?.toJson(),
      "cellTypes": cellTypes?.map((e) => e.index)?.toList(),
      "elseCell": elseCell?.toJson(),
      "lostConditionKey": lostConditionKey?.toJson(),
    };
  }

  @override
  List<Object> get props => [
        name,
        imgPath,
        tpCell,
        challenge,
        conditionKeyStolen,
        movingUndeterminedCount,
        throwDiceEffect,
        sideEffectList,
        prisonCondition,
        sideEffectListAfterTurnLost,
        moving,
        givenConditionKey,
        cellType,
        requiredConditionKey
      ];

  Cell.fromJson(Map<String, dynamic> map)
      : this(
            name: map["name"],
            tpCell: map["tpCell"] != null ? Cell.fromJson(map["tpCell"]) : null,
            conditionKeyStolen: map["conditionKeyStolen"] != null
                ? ConditionKey.fromJson(map["conditionKeyStolen"])
                : null,
            movingUndeterminedCount: map["movingUndeterminedCount"],
            challenge: map["challenge"],
            throwDiceEffect: map["throwDiceEffect"] != null
                ? ThrowDiceEffect.fromJson(map["throwDiceEffect"])
                : null,
            prisonCondition: map["prisonCondition"] != null
                ? PrisonCondition.fromJson(map["prisonCondition"])
                : null,
            moving:
                map["moving"] != null ? Moving.fromJson(map["moving"]) : null,
            givenConditionKey: map["conditionKey"] != null
                ? ConditionKey.fromJson(map["conditionKey"])
                : null,
            lostConditionKey: map["lostConditionKey"] != null
                ? ConditionKey.fromJson(map["lostConditionKey"])
                : null,
            requiredConditionKey: map["requiredConditionKey"] != null
                ? ConditionKey.fromJson(map["requiredConditionKey"])
                : null,
            imgPath: map["imgPath"],
            cellType: CellType.values[map["cellType"]],
            sideEffectListAfterTurnLost:
                List<String>.from(map["sideEffectListAfterTurnLost"]),
            sideEffectList: List<String>.from(map["sideEffectList"]),
            ifCell: map["ifCell"] != null ? Cell.fromJson(map["ifCell"]) : null,
            elseCell:
                map["elseCell"] != null ? Cell.fromJson(map["elseCell"]) : null,
            cellTypes: map["cellTypes"] != null
                ? List<int>.from(map["cellTypes"])
                    .map((e) => CellType.values[e])
                    .toList()
                : null,
            conditionIf: map["conditionIf"] != null
                ? ConditionKey.fromJson(map["conditionIf"])
                : null);

  String get givenCondition {
    if (givenConditionKey != null && cellType != CellType.battle) {
      return "Tu gagnes : ${givenConditionKey.name}.\n";
    }
    return "";
  }

  String get selfMovingLabel {
    if (moving != null && cellType == CellType.selfMoving) {
      final action =
          moving.movingType == MovingType.forward ? "avances" : "recules";
      return "Tu $action de ${moving.count} cases.\n";
    }
    return "";
  }

  String get otherMovingLabel {
    if (moving != null && cellType == CellType.otherMoving) {
      final action =
          moving.movingType == MovingType.forward ? "avancer" : "reculer";
      return "Fait $action quelqu'un de ${moving.count} cases.\n";
    }
    return "";
  }

  String get sideEffectsLabel =>
      sideEffectList.fold<String>("", (previousValue, element) {
        return previousValue + element;
      }) +
      "\n";

  String get sideEffectsLabelAfterTurnLost =>
      sideEffectListAfterTurnLost.fold<String>("", (previousValue, element) {
        return previousValue + element;
      }) +
      "\n";

  String get turnLost =>
      cellType == CellType.turnLose ? "Passe ton prochain tour.\n" : "";

  String get prisonLabel {
    if (cellType == CellType.prison) {
      return "Fait ${prisonCondition.dicePossibilitiesLabel} pour sortir.";
    }
    return "";
  }

  String get selfThrowDiceLabel {
    if (cellType == CellType.selfThrowDice) {
      return "Lance un dé. " + throwDiceEffect.sideEffect;
    }
    return "";
  }

  String get challengeLabel {
    if (cellType == CellType.selfChallenge) {
      return "$challenge ";
    }
    return "";
  }

  String get battleLabel {
    if (cellType == CellType.battle) {
      return "Choisis un adversaire.\nLe gagnant remporte ${givenConditionKey.name}.\n";
    }
    return "";
  }

  String get stealConditionKey {
    if (cellType == CellType.steal) {
      return "Vole : ${conditionKeyStolen.name}.";
    }
    return "";
  }

  String get movingUndeterminedCountLabel {
    if (movingUndeterminedCount != null) {
      return "Avance ouf recule de $movingUndeterminedCount cases.\n";
    }
    return "";
  }

  String get conditionKeyNeeded {
    if (cellType == CellType.conditionKey) {
      if (requiredConditionKey != null) {
        return "Retourne à l'année précédente. Si tu n'as pas : ${requiredConditionKey.name}.\n";
      }
      return "Retourne en ${tpCell.name}\n";
    }
    return "";
  }

  String get multiEffectLabel {
    if (cellType == CellType.multiEffect) {
      var toReturn = "";
      if (cellTypes.contains(CellType.selfMoving)) {
        final action =
            moving.movingType == MovingType.forward ? "avances" : "recules";
        toReturn +=
            "Tu $action de ${moving.count} cases.\n";
      }
      if (cellTypes.contains(CellType.conditionKeyLost)) {
        toReturn += "Tu perds : ${lostConditionKey.name}.\n";
      }
      return toReturn;
    }
    return "";
  }

  String get ifElse {
    if (cellType == CellType.ifElse) {
      return "Si tu as ${conditionIf.name}, ${ifCell.effectsLabel}Sinon ${elseCell.effectsLabel}.";
    }
    return "";
  }

  String get effectsLabel {
    return challengeLabel +
        ifElse +
        multiEffectLabel +
        stealConditionKey +
        battleLabel +
        givenCondition +
        selfMovingLabel +
        otherMovingLabel +
        sideEffectsLabel +
        movingUndeterminedCountLabel +
        prisonLabel +
        selfThrowDiceLabel +
        conditionKeyNeeded +
        turnLost +
        sideEffectsLabelAfterTurnLost;
  }
}
