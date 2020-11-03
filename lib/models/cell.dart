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
  turnLose,
  prison,
  selfThrowDice
}

class Cell extends Resource {
  final String name;
  final String imgPath;
  final List<String> sideEffectList;
  final List<String> sideEffectListAfterTurnLost;
  final ConditionKey givenConditionKey;
  final ConditionKey requiredConditionKey;
  final CellType cellType;
  final PrisonCondition prisonCondition;
  final Moving moving;
  final ThrowDiceEffect throwDiceEffect;

  Cell(
      {@required this.name,
      @required this.imgPath,
      this.givenConditionKey,
      this.prisonCondition,
      this.throwDiceEffect,
      this.moving,
      this.requiredConditionKey,
      this.sideEffectList = const [],
      this.sideEffectListAfterTurnLost = const [],
      this.cellType = CellType.noEffect})
      : assert(name != null && imgPath != null);

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "throwDiceEffect": throwDiceEffect?.toJson(),
      "imgPath": imgPath,
      "prisonCondition": prisonCondition?.toJson(),
      "moving": moving?.toJson(),
      "sideEffectList": sideEffectList,
      "sideEffectListAfterTurnLost": sideEffectListAfterTurnLost,
      "conditionKey": givenConditionKey?.toJson(),
      "requiredConditionKey": requiredConditionKey?.toJson(),
      "cellType": cellType.index
    };
  }

  @override
  List<Object> get props => [
        name,
        imgPath,
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
            requiredConditionKey: map["requiredConditionKey"] != null
                ? ConditionKey.fromJson(map["requiredConditionKey"])
                : null,
            imgPath: map["imgPath"],
            cellType: CellType.values[map["cellType"]],
            sideEffectListAfterTurnLost:
                List<String>.from(map["sideEffectListAfterTurnLost"]),
            sideEffectList: List<String>.from(map["sideEffectList"]));

  String get givenCondition {
    if (givenConditionKey != null) {
      return "Tu gagnes : ${givenConditionKey.name}.\n";
    }
    return "";
  }

  String get movingLabel {
    if (moving != null) {
      final action =
          moving.movingType == MovingType.forward ? "avances" : "recules";
      return "Tu $action de ${moving.count} cases.\n";
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

  String get effectsLabel {
    return givenCondition +
        movingLabel +
        sideEffectsLabel +
        prisonLabel +
        selfThrowDiceLabel +
        turnLost +
        sideEffectsLabelAfterTurnLost;
  }
}
