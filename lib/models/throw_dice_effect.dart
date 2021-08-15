import 'package:studrink/models/resource.dart';

class ThrowDiceEffect extends Resource {
  final String sideEffect;

  ThrowDiceEffect({required this.sideEffect});

  ThrowDiceEffect.fromJson(Map<String, dynamic> map)
      : this(sideEffect: map["sideEffect"]);

  @override
  List<Object> get props => [sideEffect];

  @override
  Map<String, dynamic> toJson() {
    return {"sideEffect": sideEffect};
  }
}
