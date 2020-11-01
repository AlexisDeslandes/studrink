import 'package:equatable/equatable.dart';

abstract class Resource extends Equatable {
  Map<String, dynamic> toJson();
}