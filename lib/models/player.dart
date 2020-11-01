import 'package:ptit_godet/models/resource.dart';

enum PlayerState { ready }

class Player extends Resource {
  static int idGenerator = 0;

  final int id;
  final String name;
  final String avatar;
  final int idCurrentCell;

  Player({this.name = "", this.avatar = "test", this.idCurrentCell = 0})
      : id = idGenerator++;

  Player.fromJson(Map<String, dynamic> map)
      : this(
            name: map["name"],
            avatar: map["avatar"],
            idCurrentCell: map["idCurrentCell"]);

  get filled => name.length > 0 && avatar.length > 0;

  PlayerState get state => PlayerState.ready; //todo change

  @override
  Map<String, dynamic> toJson() {
    return {"name": name, "avatar": avatar, "idCurrentCell": idCurrentCell};
  }

  @override
  List<Object> get props => [name, avatar, id, idCurrentCell];

  Player.copy(Player player, {String name, String avatar, int idCurrentCell})
      : this(
            name: name ?? player.name,
            avatar: avatar ?? player.avatar,
            idCurrentCell: idCurrentCell ?? player.idCurrentCell);
}
