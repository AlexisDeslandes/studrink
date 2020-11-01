import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/models/condition_key.dart';
import 'package:ptit_godet/models/resource.dart';

enum CellType { noEffect }

class Cell extends Resource {
  final String name;
  final String imgPath;
  final List<String> sideEffectList;
  final ConditionKey conditionKey;
  final CellType cellType;

  Cell(
      {@required this.name,
      @required this.imgPath,
      this.conditionKey,
      this.sideEffectList = const [],
      this.cellType = CellType.noEffect})
      : assert(name != null && imgPath != null);

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "imgPath": imgPath,
      "sideEffectList": sideEffectList,
      "conditionKey": conditionKey?.toJson()
    };
  }

  @override
  List<Object> get props => [name, imgPath, sideEffectList, conditionKey];

  Cell.fromJson(Map<String, dynamic> map)
      : this(
            name: map["name"],
            conditionKey: map["conditionKey"] != null
                ? ConditionKey.fromJson(map["conditionKey"])
                : null,
            imgPath: map["imgPath"],
            sideEffectList: List<String>.from(map["sideEffectList"]));

  String get effectsLabel =>
      sideEffectList.fold<String>("", (previousValue, element) {
        return previousValue + element;
      });
}
