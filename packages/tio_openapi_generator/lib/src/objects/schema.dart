import 'package:json_annotation/json_annotation.dart';

import '../enums.dart';
import '../internal.dart';
import '../objects.dart';

part 'schema.g.dart';

@JsonSerializable(createToJson: false)
@JsonSchemaTypeJsonConverter()
class SchemaObject extends CoreObject {
  const SchemaObject({
    super.$id,
    super.$ref,
    this.type,
    this.format,
    this.properties,
    this.minLength,
    this.maxLength,
    this.minimum,
    this.maximum,
    this.pattern,
    this.uniqueItems,
    this.items,
  });

  factory SchemaObject.fromJson(JSON json) => _$SchemaObjectFromJson(json);

  final JsonSchemaType? type;
  final JsonSchemaFormat? format;
  final Map<String, SchemaObject>? properties;

  final int? minLength;
  final int? maxLength;

  final int? minimum;
  final int? maximum;
  final String? pattern;
  final bool? uniqueItems;
  final SchemaObject? items;

  Iterable<SchemaObject> nestedSchemas({bool includeSelf = true}) {
    return [
      if (includeSelf) this,
      if (items != null) ...[
        ...items!.nestedSchemas(),
      ],
      if (properties != null) ...[
        ...properties!.values.map((e) => e.nestedSchemas()).expand((e) => e),
      ],
    ];
  }
}
