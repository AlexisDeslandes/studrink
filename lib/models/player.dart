import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/models/condition_key.dart';
import 'package:ptit_godet/models/resource.dart';
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

enum IfElseMode { none, ifMode, elseMode }

class Player extends Resource {
  static int idGenerator = 0;

  final int id;
  final String name;
  final Uint8List avatar;
  final Color color;
  final int idCurrentCell;
  final PlayerState state;
  final List<ConditionKey> conditionKeyList;
  final IfElseMode ifElseMode;

  Player(
      {this.name = "",
      int id,
      this.ifElseMode = IfElseMode.none,
      Color color,
      this.avatar,
      this.conditionKeyList = const [],
      this.idCurrentCell = 0,
      this.state = PlayerState.ready})
      : this.id = id ?? idGenerator++,
        this.color = color ?? RandomColor().randomColor();

  Player.fromJson(Map<String, dynamic> map)
      : this(
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

  get filled => name.length > 0;

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
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "color": [color.red, color.green, color.blue, color.opacity],
      "ifElseMode": ifElseMode.index,
      "avatar": base64Encode(avatar),
      "idCurrentCell": idCurrentCell,
      "state": state,
      "conditionKeyList": conditionKeyList.map((e) => e.toJson()).toList()
    };
  }

  @override
  List<Object> get props =>
      [name, avatar, id, idCurrentCell, state, ifElseMode];

  Player.copy(Player player,
      {String name,
      Uint8List avatar,
      int idCurrentCell,
      PlayerState state,
      List<ConditionKey> conditionKeyList,
      IfElseMode ifElseMode})
      : this(
            id: player.id,
            color: player.color,
            ifElseMode: ifElseMode ?? player.ifElseMode,
            name: name ?? player.name,
            state: state ?? player.state,
            conditionKeyList: conditionKeyList
                    ?.where((element) => element != null)
                    ?.toList() ??
                player.conditionKeyList,
            avatar: avatar ?? player.avatar,
            idCurrentCell: idCurrentCell ?? player.idCurrentCell);

  @override
  String toString() {
    return 'Player{id: $id, name: $name, avatar: $avatar, idCurrentCell: $idCurrentCell, state: $state, conditionKeyList: $conditionKeyList, ifElseMode: $ifElseMode}';
  }
}
