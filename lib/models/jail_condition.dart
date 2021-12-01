import 'package:studrink/models/resource.dart';

class JailCondition extends Resource {
  final List<int> dicePossibilities;

  JailCondition(this.dicePossibilities);

  JailCondition.fromJson(Map<String, dynamic> map)
      : this(List<int>.from(map["dicePossibilities"]));

  @override
  List<Object?> get props => [dicePossibilities];

  String get dicePossibilitiesLabel => dicePossibilities.join(" ou ");

  @override
  Map<String, dynamic> toJson() {
    return {"dicePossibilities": dicePossibilities};
  }
}
