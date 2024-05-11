import 'package:json_annotation/json_annotation.dart';
import 'package:tio/tio.dart';

import '../enums.dart';

part 'schema.g.dart';

@JsonSerializable(createToJson: false)
@JsonSchemaTypeJsonConverter()
class SchemaObject {
  const SchemaObject({
    this.$id,
    this.$ref,
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

  final String? $id;
  final String? $ref;

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
}
