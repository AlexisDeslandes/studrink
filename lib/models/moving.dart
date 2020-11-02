import 'package:flutter/cupertino.dart';
import 'package:ptit_godet/models/resource.dart';

enum MovingType { forward, backward }

class Moving extends Resource {
  final MovingType movingType;
  final int count;

  Moving({@required this.movingType, @required this.count})
      : assert(movingType != null && count != null);

  Moving.fromJson(Map<String, dynamic> map)
      : this(
            movingType: MovingType.values[map["movingType"]],
            count: map["count"]);

  @override
  List<Object> get props => [movingType, count];

  @override
  Map<String, dynamic> toJson() {
    return {
      "movingType": movingType.index,
      "count": count
    };
  }
}
