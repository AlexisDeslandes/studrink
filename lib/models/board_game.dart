import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/models/cell.dart';
import 'package:ptit_godet/models/resource.dart';

class BoardGame extends Resource {
  final String name;
  final List<Cell> cells;

  BoardGame({@required this.name, @required this.cells});

  BoardGame.fromJson(Map<String, dynamic> map)
      : this(
            name: map["name"],
            cells: List<Map<String, dynamic>>.from(map["cells"])
                .map((e) => Cell.fromJson(e))
                .toList());

  @override
  List<Object> get props => [name, cells];

  @override
  Map<String, dynamic> toJson() {
    return {"name": name, "cells": cells.map((e) => e.toJson()).toList()};
  }
}
