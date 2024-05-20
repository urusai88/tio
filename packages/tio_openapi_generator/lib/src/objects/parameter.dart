import 'package:json_annotation/json_annotation.dart';

import '../internal.dart';
import '../objects.dart';

part 'parameter.g.dart';

@JsonEnum(alwaysCreate: true, valueField: 'value')
enum ParameterIn {
  query('query'),
  header('headers'),
  path('path'),
  cookie('cookie');

  const ParameterIn(this.value);

  final String value;
}

@JsonSerializable(createToJson: false)
class ParameterObject {
  const ParameterObject({
    required this.name,
    required this.in$,
    this.description,
    this.required,
    this.deprecated,
    this.schema,
  });

  factory ParameterObject.fromJson(JSON json) =>
      _$ParameterObjectFromJson(json);

  final String name;
  @JsonKey(name: 'in')
  final ParameterIn in$;

  final String? description; // @TODO
  final bool? required;
  final bool? deprecated; // @TODO
  final SchemaObject? schema;
// final bool? allowEmptyValue;
}
