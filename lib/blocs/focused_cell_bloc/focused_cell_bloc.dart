import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/models/player.dart';

class FocusedCellBloc extends Bloc<FocusedCellEvent, FocusedCellState> {
  FocusedCellBloc() : super(FocusedCellState());

  @override
  Stream<FocusedCellState> mapEventToState(FocusedCellEvent event) async* {
    if (event is ChangeFocusedPlayer) {
      yield FocusedCellState(event.player);
    } else if (event is ResetFocusedCell) {
      yield FocusedCellState();
    }
  }
}

class FocusedCellState extends Equatable {
  final Player? selectedPlayer;

  const FocusedCellState([this.selectedPlayer]);

  @override
  List<Object?> get props => [selectedPlayer];
}

abstract class FocusedCellEvent extends Equatable {
  const FocusedCellEvent();

  @override
  List<Object> get props => [];
}

class ChangeFocusedPlayer extends FocusedCellEvent {
  final Player player;

  const ChangeFocusedPlayer(this.player);
}

class ResetFocusedCell extends FocusedCellEvent {
  const ResetFocusedCell();
}
