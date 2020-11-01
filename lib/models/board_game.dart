import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/models/resource.dart';

class BoardGame extends Resource {
  final String name;

  BoardGame({@required this.name});

  BoardGame.fromJson(Map<String, dynamic> map) : this(name: map["name"]);

  @override
  List<Object> get props => [name];

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name
    };
  }
}
