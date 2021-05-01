import 'dart:convert';
import 'dart:io';

import 'package:ptit_godet/storage/default_board_games.dart';

void main() {
  var f = File("txt.json");
  f.writeAsString(
      jsonEncode(DefaultBoardGames().boardGameList().first.toJson()));
}
