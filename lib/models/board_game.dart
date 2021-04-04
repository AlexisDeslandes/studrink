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
  final bool event;
  final List<String> screenshots;

  const BoardGame(
      {required this.date,
      required this.imgUrl,
      this.name = "",
      this.subTitle = "",
      this.tag = "",
      this.description = "",
      this.cells = const [],
      this.screenshots = const [],
      this.event = false});

  BoardGame.fromJson(Map<String, dynamic> map)
      : this(
            name: map["name"],
            subTitle: map["subTitle"],
            tag: map["tag"],
            imgUrl: map["imgUrl"],
            description: map["description"],
            event: map["event"] != null && map["event"] ? true : false,
            date: DateTime.fromMillisecondsSinceEpoch(map["date"]),
            cells: map["cells"] != null
                ? List<Map<String, dynamic>>.from(map["cells"])
                    .map((e) => Cell.fromJson(e))
                    .toList()
                : [],
            screenshots: map["screenshots"] != null
                ? (map["screenshots"] as List<dynamic>).cast<String>()
                : []);

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
      "date": date.millisecondsSinceEpoch,
      "event": event,
      "screenshots": screenshots
    };
  }
}
