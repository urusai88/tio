import 'package:json_annotation/json_annotation.dart';

import '../internal.dart';
import '../objects.dart';

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
