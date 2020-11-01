import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/models/resource.dart';

class ConditionKey extends Resource {
  final int id;
  final String name;

  ConditionKey({@required this.name}) : id = name.hashCode;

  @override
  List<Object> get props => [id, name];

  @override
  Map<String, dynamic> toJson() {
    return {"id": id, "name": name};
  }

  ConditionKey.fromJson(Map<String, dynamic> map) : this(name: map["name"]);
}
