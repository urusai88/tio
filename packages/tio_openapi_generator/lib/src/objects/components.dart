import 'package:json_annotation/json_annotation.dart';

import '../internal.dart';
import '../objects.dart';

part 'components.g.dart';

@JsonSerializable(createToJson: false)
class ComponentsObject {
  const ComponentsObject({required this.schemas});

  factory ComponentsObject.fromJson(JSON json) =>
      _$ComponentsObjectFromJson(json);

  final StringMap<SchemaObject>? schemas;
}
