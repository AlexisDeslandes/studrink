import 'package:ptit_godet/models/cell.dart';
import 'package:ptit_godet/models/resource.dart';

class BoardGame extends Resource {
  final String name;
  final String subTitle;
  final String tag;
  final String imgUrl;
  final String description;
  final List<Cell> cells;
  final DateTime date;

  const BoardGame(
      {this.name = "",
      this.subTitle = "",
      this.tag = "",
      this.description = "",
      this.cells = const [],
      this.imgUrl,
      this.date});

  BoardGame.fromJson(Map<String, dynamic> map)
      : this(
            name: map["name"],
            subTitle: map["subTitle"],
            tag: map["tag"],
            imgUrl: map["imgUrl"],
            description: map["description"],
            date: map["date"],
            cells: List<Map<String, dynamic>>.from(map["cells"])
                .map((e) => Cell.fromJson(e))
                .toList());

  @override
  List<Object> get props => [name, cells];

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "subTitle": subTitle,
      "tag": tag,
      "cells": cells.map((e) => e.toJson()).toList(),
      "description": description,
      "imgUrl": imgUrl,
      "date": date
    };
  }
}
