import 'package:studrink/models/cell.dart';
import 'package:studrink/models/resource.dart';

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
  final String goal;

  const BoardGame(
      {required this.date,
      required this.imgUrl,
      this.name = "",
      this.teaser = "",
      this.description = "",
      this.cells = const [],
      this.screenshots = const [],
      this.event = false,
      this.chips = const [],
      this.goal = ""});

  BoardGame.fromJson(Map<String, dynamic> json)
      : this(
            goal: json["goal"],
            name: json["name"],
            chips: json["chips"] != null
                ? (json["chips"] as List<dynamic>).cast<String>()
                : [],
            teaser: json["teaser"],
            imgUrl: json["imgUrl"] ?? "assets/icons/beer.svg",
            description: json["description"],
            event: json["event"] != null && json["event"] ? true : false,
            date: json["date"] != null
                ? DateTime.fromMillisecondsSinceEpoch(json["date"])
                : DateTime.now(),
            cells: json["cells"] != null
                ? List<Map<String, dynamic>>.from(json["cells"])
                    .map((e) => Cell.fromJson(e))
                    .toList()
                : [],
            screenshots: json["screenshots"] != null
                ? (json["screenshots"] as List<dynamic>).cast<String>()
                : []);

  @override
  List<Object> get props => [name];

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "teaser": teaser,
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
