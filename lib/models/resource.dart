import 'package:equatable/equatable.dart';

abstract class Resource extends Equatable {
  const Resource();

  Map<String, dynamic> toJson();
}
