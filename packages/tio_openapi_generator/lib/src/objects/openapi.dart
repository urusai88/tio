import 'package:json_annotation/json_annotation.dart';
import 'package:tio/tio.dart';

import '../entities.dart';
import '../internal.dart';

part 'openapi.g.dart';

@JsonSerializable(createToJson: false)
class OpenApiObject {
  const OpenApiObject({
    required this.openapi,
    this.components,
    this.paths,
  });

  factory OpenApiObject.fromJson(JSON json) => _$OpenApiObjectFromJson(json);

  final String openapi;
  final ComponentsObject? components;
  final StringMap<PathItemObject>? paths;
}
