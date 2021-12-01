import 'package:studrink/models/board_game.dart';
import 'package:studrink/models/condition_key.dart';
import 'package:studrink/models/moving.dart';
import 'package:studrink/models/player.dart';
import 'package:studrink/models/jail_condition.dart';
import 'package:studrink/models/resource.dart';
import 'package:studrink/models/throw_dice_effect.dart';

enum CellType {
  noEffect,
  conditionKey,
  selfMoving,
  otherMoving,
  turnLose,
  jail,
  selfThrowDice,
  selfChallenge,
  selfMovingPlayerChose,
  battle,
  steal,
  ifElse,
  finish
}

extension CellTypeExtension on CellType {
  String get value {
    final content = this.toString().split('.').last;
    return content[0] + content.substring(1, content.length);
  }
}

class Cell extends Resource {
  Cell.nullable() : this(name: "", imgPath: "");

  final String name;
  final String? imgPath;
  final CellType cellType;
  final List<String> sideEffectList;
  final List<String> sideEffectListAfterTurnLost;
  final ConditionKey? givenConditionKey;
  final ConditionKey? requiredConditionKey;
  final ConditionKey? conditionKeyStolen;
  final JailCondition? jailCondition;
  final Moving? moving;
  final ThrowDiceEffect? throwDiceEffect;
  final String? challenge;
  final int? movingUndeterminedCount;
  final Cell? tpCell;
  final Cell? ifCell;
  final Cell? elseCell;
  final ConditionKey? conditionIf;
  final ConditionKey? lostConditionKey;
  final int? diceCondition;
  final int? tpCellIndex;

  Cell(
      {required this.name,
      required this.imgPath,
      this.movingUndeterminedCount,
      this.givenConditionKey,
      this.jailCondition,
      this.throwDiceEffect,
      this.moving,
      this.requiredConditionKey,
      this.sideEffectList = const [],
      this.sideEffectListAfterTurnLost = const [],
      this.cellType = CellType.noEffect,
      this.challenge,
      this.conditionKeyStolen,
      this.lostConditionKey,
      this.tpCell,
      this.conditionIf,
      this.ifCell,
      this.elseCell,
      this.diceCondition,
      this.tpCellIndex});

  factory Cell.fromCode(String code, {String divider = "£"}) {
    final parts = code.split(divider);
    var name,
        diceCondition,
        tpCell,
        cks,
        muc,
        ch,
        tde,
        ip,
        pc,
        m,
        sel,
        selatl,
        ck,
        rck,
        ct,
        ic,
        ci,
        ec,
        lck;
    for (var value in parts) {
      if (value.startsWith("n:"))
        name = value.substring(2);
      else if (value.startsWith("dc:"))
        diceCondition = int.parse(value.substring(3));
      else if (value.startsWith("tc:"))
        tpCell = int.parse(value.substring(3)); //index of the cell
      else if (value.startsWith("cks:"))
        cks = ConditionKey(name: value.substring(3)); //condition key
      else if (value.startsWith("muc:"))
        muc = int.parse(value.substring(4)); //moving
      else if (value.startsWith("ch:"))
        ch = value.substring(3); //Challenge
      else if (value.startsWith("tde:"))
        tde = value.substring(4); //throw dice effect
      else if (value.startsWith("ip:"))
        ip = value.substring(3); //img path
      else if (value.startsWith("pc:")) //prison condition List<int>
        pc = JailCondition(
            (value.substring(3).split(";")).map((e) => int.parse(e)).toList());
      else if (value.startsWith("m:")) {
        final type = MovingType.values[(int.parse(value.substring(2, 3)))];
        m = Moving(
            movingType: type, count: int.parse(value.substring(3))); //moving
      } else if (value.startsWith("sel:"))
        sel = value.substring(4); //sideEffectList
      else if (value.startsWith("selatl:"))
        selatl = value.substring(7); //sideEffectAfterTurnLost
      else if (value.startsWith("ck:"))
        ck = ConditionKey(name: value.substring(3)); //condition key
      else if (value.startsWith("rck:"))
        rck = ConditionKey(name: value.substring(4)); //required condition key
      else if (value.startsWith("t:")) //type of cell
        ct = int.parse(value.substring(2));
      else if (value.startsWith("ic:")) //ifCell
        ic = Cell.fromCode(value.substring(4, value.length - 1), divider: "§");
      else if (value.startsWith("ci:")) //condition if
        ci = ConditionKey(name: value.substring(3));
      else if (value.startsWith("ec:")) //else cell
        ec = Cell.fromCode(value.substring(4, value.length - 1), divider: "§");
      else if (value.startsWith("lck:")) // condition key
        lck = ConditionKey(name: value.substring(4));
    }
    return Cell(
        name: name ?? "",
        imgPath: ip,
        cellType: CellType.values[ct],
        challenge: ch,
        diceCondition: diceCondition,
        elseCell: ec,
        ifCell: ic,
        moving: m,
        jailCondition: pc,
        movingUndeterminedCount: muc,
        sideEffectList: sel != null ? [sel] : [],
        sideEffectListAfterTurnLost: selatl != null ? [selatl] : [],
        throwDiceEffect: tde != null ? ThrowDiceEffect(sideEffect: tde) : null,
        tpCellIndex: tpCell,
        conditionIf: ci,
        conditionKeyStolen: cks,
        givenConditionKey: ck,
        lostConditionKey: lck,
        requiredConditionKey: rck);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "diceCondition": diceCondition,
      "tpCell": tpCell?.toJson(),
      "conditionKeyStolen": conditionKeyStolen?.toJson(),
      "movingUndeterminedCount": movingUndeterminedCount,
      "challenge": challenge,
      "throwDiceEffect": throwDiceEffect?.toJson(),
      "imgPath": imgPath,
      "prisonCondition": jailCondition?.toJson(),
      "moving": moving?.toJson(),
      "sideEffectList": sideEffectList,
      "sideEffectListAfterTurnLost": sideEffectListAfterTurnLost,
      "conditionKey": givenConditionKey?.toJson(),
      "requiredConditionKey": requiredConditionKey?.toJson(),
      "cellType": cellType.index,
      "ifCell": ifCell?.toJson(),
      "conditionIf": conditionIf?.toJson(),
      "elseCell": elseCell?.toJson(),
      "lostConditionKey": lostConditionKey?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        name,
        imgPath,
        tpCell,
        challenge,
        conditionKeyStolen,
        movingUndeterminedCount,
        throwDiceEffect,
        sideEffectList,
        jailCondition,
        sideEffectListAfterTurnLost,
        moving,
        givenConditionKey,
        cellType,
        requiredConditionKey
      ];

  Cell.fromJson(Map<String, dynamic> map)
      : this(
            name: map["name"],
            diceCondition: map["diceCondition"],
            tpCell: map["tpCell"] != null ? Cell.fromJson(map["tpCell"]) : null,
            conditionKeyStolen: map["conditionKeyStolen"] != null
                ? ConditionKey.fromJson(map["conditionKeyStolen"])
                : null,
            movingUndeterminedCount: map["movingUndeterminedCount"],
            challenge: map["challenge"],
            throwDiceEffect: map["throwDiceEffect"] != null
                ? ThrowDiceEffect.fromJson(map["throwDiceEffect"])
                : null,
            jailCondition: map["prisonCondition"] != null
                ? JailCondition.fromJson(map["prisonCondition"])
                : null,
            moving:
                map["moving"] != null ? Moving.fromJson(map["moving"]) : null,
            givenConditionKey: map["conditionKey"] != null
                ? ConditionKey.fromJson(map["conditionKey"])
                : null,
            lostConditionKey: map["lostConditionKey"] != null
                ? ConditionKey.fromJson(map["lostConditionKey"])
                : null,
            requiredConditionKey: map["requiredConditionKey"] != null
                ? ConditionKey.fromJson(map["requiredConditionKey"])
                : null,
            imgPath: map["imgPath"],
            cellType: CellType.values[map["cellType"]],
            sideEffectListAfterTurnLost:
                List<String>.from(map["sideEffectListAfterTurnLost"]),
            sideEffectList: List<String>.from(map["sideEffectList"]),
            ifCell: map["ifCell"] != null ? Cell.fromJson(map["ifCell"]) : null,
            elseCell:
                map["elseCell"] != null ? Cell.fromJson(map["elseCell"]) : null,
            conditionIf: map["conditionIf"] != null
                ? ConditionKey.fromJson(map["conditionIf"])
                : null);

  String get givenCondition {
    if (givenConditionKey != null && cellType != CellType.battle) {
      return "Tu gagnes : ${givenConditionKey!.name}.\n";
    }
    return "";
  }

  String get selfMovingLabel {
    if (moving != null && cellType == CellType.selfMoving) {
      final action =
          moving!.movingType == MovingType.forward ? "avances" : "recules";
      return "Tu $action de ${moving!.count} cases.\n";
    }
    return "";
  }

  String get otherMovingLabel {
    if (moving != null && cellType == CellType.otherMoving) {
      final action =
          moving!.movingType == MovingType.forward ? "avancer" : "reculer";
      return "Fait $action quelqu'un de ${moving!.count} cases.\n";
    }
    return "";
  }

  String get sideEffectsLabel {
    final effects = sideEffectList.fold<String>("", (previousValue, element) {
      return previousValue + " " + element;
    });
    if (effects.isNotEmpty) return effects + "\n";
    return "";
  }

  String get sideEffectsLabelAfterTurnLost {
    final effects =
        sideEffectListAfterTurnLost.fold<String>("", (previousValue, element) {
      return previousValue + element;
    });
    if (effects.isNotEmpty) return effects + "\n";
    return "";
  }

  String get turnLost =>
      cellType == CellType.turnLose ? "Passe ton prochain tour.\n" : "";

  String get prisonLabel {
    if (cellType == CellType.jail) {
      return "Fait ${jailCondition!.dicePossibilitiesLabel} pour sortir.\nMax 3 tour de détention.\n";
    }
    return "";
  }

  String get selfThrowDiceLabel {
    if (cellType == CellType.selfThrowDice) {
      return "Lance un dé. " + throwDiceEffect!.sideEffect + "\n";
    }
    return "";
  }

  String get challengeLabel {
    if (cellType == CellType.selfChallenge) {
      return "$challenge ";
    }
    return "";
  }

  String get battleLabel {
    if (cellType == CellType.battle) {
      return "Choisis un adversaire.\nLe gagnant remporte ${givenConditionKey!.name}.\n";
    }
    return "";
  }

  String get stealConditionKey {
    if (cellType == CellType.steal) {
      return "Vole : ${conditionKeyStolen!.name}.\n";
    }
    return "";
  }

  String get movingUndeterminedCountLabel {
    if (movingUndeterminedCount != null) {
      return "Avance ou recule de $movingUndeterminedCount case(s).\n";
    }
    return "";
  }

  String get conditionKeyNeeded {
    if (cellType == CellType.conditionKey) {
      if (requiredConditionKey != null) {
        return "Retourne à l'année précédente. Si tu n'as pas : ${requiredConditionKey!.name}.\n";
      }
      return "Retourne en ${tpCell!.name}.\n";
    }
    return "";
  }

  String get ifElse {
    if (cellType == CellType.ifElse) {
      return "Si tu as ${conditionIf!.name}, ${ifCell!.effectsLabel}Sinon ${elseCell!.effectsLabel}.";
    }
    return "";
  }

  String get conditionKeyLostLabel {
    if (lostConditionKey != null) {
      return "Tu perds : ${lostConditionKey!.name}.\n";
    }
    return "";
  }

  String get diceConditionLabel {
    if (diceCondition != null) {
      return "Fait un $diceCondition pour terminer.\n";
    }
    return "";
  }

  String get effectsLabel {
    final toReturn = diceConditionLabel +
        challengeLabel +
        ifElse +
        conditionKeyLostLabel +
        stealConditionKey +
        battleLabel +
        selfMovingLabel +
        otherMovingLabel +
        sideEffectsLabel +
        movingUndeterminedCountLabel +
        prisonLabel +
        selfThrowDiceLabel +
        conditionKeyNeeded +
        givenCondition +
        turnLost +
        sideEffectsLabelAfterTurnLost;
    if (toReturn.endsWith("\n\n")) {
      return toReturn.substring(0, toReturn.length - 1);
    } else if (toReturn.endsWith("\n.")) {
      return toReturn.substring(0, toReturn.length - 2);
    }
    return toReturn;
  }

  Cell? actualCell(IfElseMode ifElseMode) {
    return ifElseMode == IfElseMode.ifMode
        ? this.ifCell
        : ifElseMode == IfElseMode.elseMode
            ? this.elseCell
            : this;
  }

  Cell.copy(Cell e, {Cell? tpCell})
      : this(
            name: e.name,
            imgPath: e.imgPath,
            cellType: e.cellType,
            challenge: e.challenge,
            diceCondition: e.diceCondition,
            elseCell: e.elseCell,
            ifCell: e.ifCell,
            moving: e.moving,
            jailCondition: e.jailCondition,
            movingUndeterminedCount: e.movingUndeterminedCount,
            sideEffectList: e.sideEffectList,
            sideEffectListAfterTurnLost: e.sideEffectListAfterTurnLost,
            throwDiceEffect: e.throwDiceEffect,
            tpCellIndex: e.tpCellIndex,
            conditionIf: e.conditionIf,
            conditionKeyStolen: e.conditionKeyStolen,
            givenConditionKey: e.givenConditionKey,
            lostConditionKey: e.lostConditionKey,
            requiredConditionKey: e.requiredConditionKey,
            tpCell: tpCell ?? e.tpCell);
}
