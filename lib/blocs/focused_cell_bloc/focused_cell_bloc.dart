import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/models/player.dart';

class FocusedCellBloc extends Bloc<FocusedCellEvent, FocusedCellState> {
  FocusedCellBloc() : super(FocusedCellState());

  @override
  Stream<FocusedCellState> mapEventToState(FocusedCellEvent event) async* {
    if (event is ChangeFocusedCell) {
      final playerList = event.playerList;
      if (playerList.length > 0) {
        yield FocusedCellState(
            playerList: playerList, selectedPlayer: playerList[0]);
      } else {
        yield FocusedCellState();
      }
    } else if (event is ChangeFocusedPlayer) {
      yield FocusedCellState.copy(state, selectedPlayer: event.player);
    }
  }
}

class FocusedCellState extends Equatable {
  final List<Player> playerList;
  final Player selectedPlayer;

  const FocusedCellState({this.playerList = const [], this.selectedPlayer});

  FocusedCellState.copy(FocusedCellState old, {Player selectedPlayer})
      : this(
            playerList: old.playerList,
            selectedPlayer: selectedPlayer ?? old.selectedPlayer);

  @override
  List<Object> get props => [playerList, selectedPlayer];
}

abstract class FocusedCellEvent extends Equatable {
  const FocusedCellEvent();

  @override
  List<Object> get props => [];
}

class ChangeFocusedCell extends FocusedCellEvent {
  final List<Player> playerList;

  const ChangeFocusedCell({this.playerList = const []});
}

class ChangeFocusedPlayer extends FocusedCellEvent {
  final Player player;

  const ChangeFocusedPlayer(this.player);
}
