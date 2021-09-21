import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiceBloc extends Bloc<ShowDice, DiceState> {
  DiceBloc() : super(const DiceState.empty());

  @override
  Stream<DiceState> mapEventToState(ShowDice event) async* {
    final diceValue = event.diceValue;
    yield DiceState.copy(state, lastDiceValue: diceValue);
    for (var i = diceValue; i >= 0; i--) {
      await Future.delayed(Duration(milliseconds: 150));
      yield DiceState.copy(state, diceValue: i);
    }
  }
}

class DiceState extends Equatable {
  const DiceState({required this.diceValue, required this.lastDiceValue});

  const DiceState.empty() : this(diceValue: 0, lastDiceValue: 0);

  DiceState.copy(DiceState old, {int? diceValue, int? lastDiceValue})
      : this(
            diceValue: diceValue ?? old.diceValue,
            lastDiceValue: lastDiceValue ?? old.lastDiceValue);

  final int diceValue;
  final int lastDiceValue;

  @override
  List<Object?> get props => [diceValue, lastDiceValue];
}

class ShowDice extends Equatable {
  final int diceValue;

  ShowDice(this.diceValue);

  @override
  List<Object?> get props => [diceValue];
}
