import 'package:ptit_godet/models/condition_key.dart';
import 'package:ptit_godet/models/resource.dart';

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
  chosePlayerMoving
}

class Player extends Resource {
  static int idGenerator = 0;

  final int id;
  final String name;
  final String avatar;
  final int idCurrentCell;
  final PlayerState state;
  final List<ConditionKey> conditionKeyList;

  Player(
      {this.name = "",
      this.avatar = "test",
      this.conditionKeyList = const [],
      this.idCurrentCell = 0,
      this.state = PlayerState.ready})
      : id = idGenerator++;

  Player.fromJson(Map<String, dynamic> map)
      : this(
            name: map["name"],
            conditionKeyList:
                List<Map<String, dynamic>>.from(map["conditionKeyList"])
                    .map((map) => ConditionKey.fromJson(map))
                    .toList(),
            state: map["state"],
            avatar: map["avatar"],
            idCurrentCell: map["idCurrentCell"]);

  get filled => name.length > 0 && avatar.length > 0;

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "avatar": avatar,
      "idCurrentCell": idCurrentCell,
      "state": state,
      "conditionKeyList": conditionKeyList.map((e) => e.toJson()).toList()
    };
  }

  @override
  List<Object> get props => [name, avatar, id, idCurrentCell, state];

  Player.copy(Player player,
      {String name,
      String avatar,
      int idCurrentCell,
      PlayerState state,
      List<ConditionKey> conditionKeyList})
      : this(
            name: name ?? player.name,
            state: state ?? player.state,
            conditionKeyList: conditionKeyList
                    ?.where((element) => element != null)
                    ?.toList() ??
                player.conditionKeyList,
            avatar: avatar ?? player.avatar,
            idCurrentCell: idCurrentCell ?? player.idCurrentCell);
}
