import 'package:json_annotation/json_annotation.dart';
import 'package:tio/tio.dart';

import '../entities.dart';
import '../internal.dart';

part 'components.g.dart';

@JsonSerializable(createToJson: false)
class ComponentsObject {
  const ComponentsObject({required this.schemas});

  factory ComponentsObject.fromJson(JSON json) =>
      _$ComponentsObjectFromJson(json);

  final StringMap<SchemaObject> schemas;
}
