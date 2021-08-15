import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/models/condition_key.dart';
import 'package:ptit_godet/models/resource.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:random_color/random_color.dart';

enum PlayerState {
  ready,
  canEnd,
  returnPreviousCheckPoint,
  moving,
  preTurnLost,
  turnLost,
  throwDice,
  thrownDice,
  selfChallenge,
  choseDirection,
  choseOpponent,
  waitForWinner,
  chosePlayerMoving,
  stealConditionKey,
  winner
}

enum DrinkType { sips, oneGulp, cemetery, shot }

extension DrinkTypeExtension on DrinkType {
  String get extractedLabel {
    switch (this) {
      case DrinkType.sips:
        return "tu bois";
      case DrinkType.oneGulp:
        return "cul sec";
      case DrinkType.cemetery:
        return "cimetière";
      case DrinkType.shot:
        return "shot";
    }
  }

  String get label {
    switch (this) {
      case DrinkType.sips:
        return "gorgée(s)";
      case DrinkType.oneGulp:
        return "cul(s) sec(s)";
      case DrinkType.cemetery:
        return "cimetière(s)";
      case DrinkType.shot:
        return "shot(s)";
    }
  }
}

enum IfElseMode { none, ifMode, elseMode }

class Player extends Resource implements Comparable<Player> {
  static int idGenerator = 0;

  final int id;
  final String name;
  final Uint8List? avatar;
  final Color color;
  final int idCurrentCell;
  final PlayerState state;
  final List<ConditionKey> conditionKeyList;
  final IfElseMode ifElseMode;
  final int lastDiceValue;
  final int jailTurnCount;
  final Map<DrinkType, int> drinkMap;

  const Player(
      {required this.id,
      required this.color,
      this.conditionKeyList = const [],
      this.idCurrentCell = 0,
      this.lastDiceValue = 0,
      this.jailTurnCount = 0,
      this.name = "",
      this.ifElseMode = IfElseMode.none,
      this.state = PlayerState.ready,
      this.drinkMap = const {
        DrinkType.sips: 0,
        DrinkType.cemetery: 0,
        DrinkType.oneGulp: 0,
        DrinkType.shot: 0
      },
      this.avatar});

  factory Player.addSips(Player e, {required int sipsCount}) {
    return Player.copy(e, drinkMap: {
      ...e.drinkMap,
      DrinkType.sips: e.drinkMap[DrinkType.sips]! + sipsCount
    });
  }

  Player.fromGenerator()
      : this(color: RandomColor().randomColor(), id: idGenerator++);

  Player.copy(Player player,
      {String? name,
      Uint8List? avatar,
      int? idCurrentCell,
      PlayerState? state,
      List<ConditionKey>? conditionKeyList,
      IfElseMode? ifElseMode,
      int? lastDiceValue,
      int? jailTurnCount,
      Map<DrinkType, int>? drinkMap})
      : this(
            id: player.id,
            color: player.color,
            ifElseMode: ifElseMode ?? player.ifElseMode,
            name: name ?? player.name,
            state: state ?? player.state,
            conditionKeyList: conditionKeyList ?? player.conditionKeyList,
            avatar: avatar ?? player.avatar,
            idCurrentCell: idCurrentCell ?? player.idCurrentCell,
            lastDiceValue: lastDiceValue ?? player.lastDiceValue,
            jailTurnCount: jailTurnCount ?? player.jailTurnCount,
            drinkMap: drinkMap ?? player.drinkMap);

  Player.fromJson(Map<String, dynamic> map)
      : this(
            id: map["id"],
            name: map["name"],
            color: Color.fromRGBO(map["color"][0], map["color"][1],
                map["color"][2], map["color"][3]),
            ifElseMode: IfElseMode.values[(map["ifElseMode"] as int)],
            conditionKeyList:
                List<Map<String, dynamic>>.from(map["conditionKeyList"])
                    .map((map) => ConditionKey.fromJson(map))
                    .toList(),
            state: map["state"],
            avatar: base64Decode(map["avatar"]),
            idCurrentCell: map["idCurrentCell"]);

  bool get filled => name.length > 0;

  List<String> get conditionKeyLabels {
    return this
        .conditionKeyList
        .fold<Map<ConditionKey, int>>(
            {},
            (previousValue, element) => previousValue
              ..update(element, (value) => value + 1, ifAbsent: () => 1))
        .entries
        .map((e) => "${e.value} ${e.key.name}(s)")
        .toList();
  }

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
        "color": [color.red, color.green, color.blue, color.opacity],
        "ifElseMode": ifElseMode.index,
        "avatar": avatar != null ? base64Encode(avatar!) : null,
        "idCurrentCell": idCurrentCell,
        "state": state,
        "conditionKeyList": conditionKeyList.map((e) => e.toJson()).toList()
      };

  @override
  List<Object?> get props =>
      [name, avatar, idCurrentCell, state, ifElseMode, lastDiceValue, drinkMap];

  @override
  String toString() {
    return 'Player{name: $name, avatar: $avatar, idCurrentCell: $idCurrentCell, state: $state, conditionKeyList: $conditionKeyList, ifElseMode: $ifElseMode}';
  }

  @override
  int compareTo(Player other) {
    final idCellComparison = other.idCurrentCell.compareTo(this.idCurrentCell);
    if (idCellComparison != 0) return idCellComparison;
    return other.conditionKeyList.length
        .compareTo(this.conditionKeyList.length);
  }
}
