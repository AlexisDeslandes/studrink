import 'package:ptit_godet/models/cell.dart';
import 'package:ptit_godet/models/resource.dart';

class BoardGame extends Resource {
  final String name;
  final String teaser;
  final String imgUrl;
  final String description;
  final List<Cell> cells;
  final DateTime date;
  final bool event;
  final List<String> screenshots;
  final List<String> chips;

  const BoardGame(
      {required this.date,
      required this.imgUrl,
      this.name = "",
      this.teaser = "",
      this.description = "",
      this.cells = const [],
      this.screenshots = const [],
      this.event = false,
      this.chips = const []});

  BoardGame.fromJson(Map<String, dynamic> map)
      : this(
            name: map["name"],
            chips: map["chips"] != null
                ? (map["chips"] as List<dynamic>).cast<String>()
                : [],
            teaser: map["teaser"],
            imgUrl: map["imgUrl"] ?? "assets/icons/beer.svg",
            description: map["description"],
            event: map["event"] != null && map["event"] ? true : false,
            date: map["date"] != null
                ? DateTime.fromMillisecondsSinceEpoch(map["date"])
                : DateTime.now(),
            cells: map["cells"] != null
                ? List<Map<String, dynamic>>.from(map["cells"])
                    .map((e) => Cell.fromJson(e))
                    .toList()
                : [],
            screenshots: map["screenshots"] != null
                ? (map["screenshots"] as List<dynamic>).cast<String>()
                : []);

  @override
  List<Object> get props => [name];

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "tag": teaser,
      "cells": cells.map((e) => e.toJson()).toList(),
      "description": description,
      "imgUrl": imgUrl,
      "date": date.millisecondsSinceEpoch,
      "event": event,
      "screenshots": screenshots,
      "chips": chips
    };
  }
}
