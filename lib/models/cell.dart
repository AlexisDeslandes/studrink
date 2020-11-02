import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/models/condition_key.dart';
import 'package:ptit_godet/models/moving.dart';
import 'package:ptit_godet/models/resource.dart';

enum CellType { noEffect, conditionKey, selfMoving }

class Cell extends Resource {
  final String name;
  final String imgPath;
  final List<String> sideEffectList;
  final ConditionKey givenConditionKey;
  final ConditionKey requiredConditionKey;
  final CellType cellType;
  final Moving moving;

  Cell(
      {@required this.name,
      @required this.imgPath,
      this.givenConditionKey,
      this.moving,
      this.requiredConditionKey,
      this.sideEffectList = const [],
      this.cellType = CellType.noEffect})
      : assert(name != null && imgPath != null);

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "imgPath": imgPath,
      "moving": moving?.toJson(),
      "sideEffectList": sideEffectList,
      "conditionKey": givenConditionKey?.toJson(),
      "requiredConditionKey": requiredConditionKey?.toJson(),
      "cellType": cellType.index
    };
  }

  @override
  List<Object> get props => [
        name,
        imgPath,
        sideEffectList,
        moving,
        givenConditionKey,
        cellType,
        requiredConditionKey
      ];

  Cell.fromJson(Map<String, dynamic> map)
      : this(
            name: map["name"],
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

  String get effectsLabel {
    final sideEffects =
        sideEffectList.fold<String>("", (previousValue, element) {
      return previousValue + element;
    });
    return givenCondition + movingLabel + sideEffects;
  }
}
