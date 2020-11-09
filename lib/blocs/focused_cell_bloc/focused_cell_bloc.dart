import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/models/cell.dart';
import 'package:ptit_godet/models/player.dart';

class FocusedCellBloc extends Bloc<FocusedCellEvent, FocusedCellState> {
  FocusedCellBloc() : super(FocusedCellState());

  @override
  Stream<FocusedCellState> mapEventToState(FocusedCellEvent event) async* {
    if (event is ChangeFocusedCell) {
      final playerList = event.playerList;
      if (playerList.length > 0) {
        yield FocusedCellState(
            cell: event.cell,
            playerList: playerList,
            selectedPlayer: playerList[0]);
      } else {
        yield FocusedCellState(cell: event.cell);
      }
    } else if (event is ChangeFocusedPlayer) {
      yield FocusedCellState.copy(state, selectedPlayer: event.player);
    }
  }
}

class FocusedCellState extends Equatable {
  final List<Player> playerList;
  final Player selectedPlayer;
  final Cell cell;

  const FocusedCellState(
      {this.playerList = const [], this.selectedPlayer, this.cell});

  FocusedCellState.copy(FocusedCellState old,
      {Player selectedPlayer, Cell cell})
      : this(
            playerList: old.playerList,
            cell: cell ?? old.cell,
            selectedPlayer: selectedPlayer ?? old.selectedPlayer);

  @override
  List<Object> get props => [playerList, selectedPlayer, cell];
}

abstract class FocusedCellEvent extends Equatable {
  const FocusedCellEvent();

  @override
  List<Object> get props => [];
}

class ChangeFocusedCell extends FocusedCellEvent {
  final List<Player> playerList;
  final Cell cell;

  const ChangeFocusedCell({this.playerList = const [], @required this.cell});
}

class ChangeFocusedPlayer extends FocusedCellEvent {
  final Player player;

  const ChangeFocusedPlayer(this.player);
}
