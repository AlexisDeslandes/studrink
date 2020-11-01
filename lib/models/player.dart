import 'package:ptit_godet/models/resource.dart';

enum PlayerState { ready, canEnd }

class Player extends Resource {
  static int idGenerator = 0;

  final int id;
  final String name;
  final String avatar;
  final int idCurrentCell;
  final PlayerState state;

  Player(
      {this.name = "",
      this.avatar = "test",
      this.idCurrentCell = 0,
      this.state = PlayerState.ready})
      : id = idGenerator++;

  Player.fromJson(Map<String, dynamic> map)
      : this(
            name: map["name"],
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
      "state": state
    };
  }

  @override
  List<Object> get props => [name, avatar, id, idCurrentCell, state];

  Player.copy(Player player,
      {String name, String avatar, int idCurrentCell, PlayerState state})
      : this(
            name: name ?? player.name,
            state: state ?? player.state,
            avatar: avatar ?? player.avatar,
            idCurrentCell: idCurrentCell ?? player.idCurrentCell);
}
