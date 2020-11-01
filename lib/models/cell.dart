import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/models/condition_key.dart';
import 'package:ptit_godet/models/resource.dart';

enum CellType { noEffect, conditionKey }

class Cell extends Resource {
  final String name;
  final String imgPath;
  final List<String> sideEffectList;
  final ConditionKey givenConditionKey;
  final ConditionKey requiredConditionKey;
  final CellType cellType;

  Cell(
      {@required this.name,
      @required this.imgPath,
      this.givenConditionKey,
      this.requiredConditionKey,
      this.sideEffectList = const [],
      this.cellType = CellType.noEffect})
      : assert(name != null && imgPath != null);

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "imgPath": imgPath,
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
        givenConditionKey,
        cellType,
        requiredConditionKey
      ];

  Cell.fromJson(Map<String, dynamic> map)
      : this(
            name: map["name"],
            givenConditionKey: map["conditionKey"] != null
                ? ConditionKey.fromJson(map["conditionKey"])
                : null,
            requiredConditionKey: map["requiredConditionKey"] != null
                ? ConditionKey.fromJson(map["requiredConditionKey"])
                : null,
            imgPath: map["imgPath"],
            cellType: CellType.values[map["cellType"]],
            sideEffectList: List<String>.from(map["sideEffectList"]));

  String get effectsLabel =>
      sideEffectList.fold<String>("", (previousValue, element) {
        return previousValue + element;
      });
}
