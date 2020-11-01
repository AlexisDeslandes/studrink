import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/models/resource.dart';

class Cell extends Resource {
  final String name;
  final String imgPath;

  Cell({@required this.name, @required this.imgPath})
      : assert(name != null && imgPath != null);

  @override
  Map<String, dynamic> toJson() {
    return {"name": name, "imgPath": imgPath};
  }

  @override
  List<Object> get props => [name, imgPath];

  Cell.fromJson(Map<String, dynamic> map)
      : this(name: map["name"], imgPath: map["imgPath"]);

  String get effectsLabel => "Tu passes ton tour";
}
