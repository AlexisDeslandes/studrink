import 'package:studrink/models/resource.dart';

class ConditionKey extends Resource {
  ConditionKey({required this.name}) : id = name.hashCode;

  ConditionKey.nullable() : this(name: "");

  final int id;
  final String name;

  @override
  List<Object> get props => [id, name];

  @override
  Map<String, dynamic> toJson() {
    return {"id": id, "name": name};
  }

  ConditionKey.fromJson(Map<String, dynamic> map) : this(name: map["name"]);

  @override
  String toString() {
    return 'ConditionKey{id: $id, name: $name}';
  }
}
