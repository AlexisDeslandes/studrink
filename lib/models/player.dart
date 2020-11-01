import 'package:ptit_godet/models/resource.dart';

class Player extends Resource {
  static int idGenerator = 0;

  final int id;
  final String name;
  final String avatar;

  Player({this.name = "", this.avatar = "test"}) : id = idGenerator++;

  Player.fromJson(Map<String, dynamic> map)
      : this(name: map["name"], avatar: map["avatar"]);

  get filled => name.length > 0 && avatar.length > 0;

  @override
  Map<String, dynamic> toJson() {
    return {"name": name, "avatar": avatar};
  }

  @override
  List<Object> get props => [name, avatar, id];

  Player.copy(Player player, {String name, String avatar})
      : this(name: name ?? player.name, avatar: avatar ?? player.avatar);
}
