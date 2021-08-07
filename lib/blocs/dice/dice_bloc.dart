import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiceBloc extends Bloc<ShowDice, DiceState> {
  DiceBloc() : super(DiceState(0));

  @override
  Stream<DiceState> mapEventToState(ShowDice event) async* {
    final diceValue = event.diceValue;
    for (var i = diceValue; i >= 0; i--) {
      await Future.delayed(Duration(milliseconds: 150));
      yield DiceState(i);
    }
  }
}

class DiceState extends Equatable {
  final int diceValue;
  //todo lastDiceValue

  DiceState(this.diceValue);

  @override
  List<Object> get props => [diceValue];
}

class ShowDice extends Equatable {
  final int diceValue;

  ShowDice(this.diceValue);

  @override
  List<Object> get props => [diceValue];
}
