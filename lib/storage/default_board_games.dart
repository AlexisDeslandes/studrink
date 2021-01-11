import 'package:ptit_godet/models/board_game.dart';
import 'package:ptit_godet/models/cell.dart';
import 'package:ptit_godet/models/condition_key.dart';
import 'package:ptit_godet/models/moving.dart';
import 'package:ptit_godet/models/prison_condition.dart';
import 'package:ptit_godet/models/throw_dice_effect.dart';

class DefaultBoardGames {
  static const DefaultBoardGames _instance = DefaultBoardGames._();

  factory DefaultBoardGames() => _instance;

  const DefaultBoardGames._();

  List<BoardGame> boardGameList() {
    return [
      BoardGame(name: "Jeu de l'oie", cells: [
        Cell(
            name: "Rentrée",
            imgPath: "",
            sideEffectList: ["C'est la rentrée !"]),


        Cell(
            name: "Embauche",
            imgPath: "",
            sideEffectList: [
              "Tu bois la différence.",
              "Tout le monde finira son verre pour fêter l'embauche."
            ],
            cellType: CellType.finish,
            diceCondition: 6)
      ])
    ];
  }
}
