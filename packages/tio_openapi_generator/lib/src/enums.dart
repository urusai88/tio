import 'package:json_annotation/json_annotation.dart';

part 'enums.g.dart';

@JsonEnum(alwaysCreate: true, valueField: 'value')
enum HttpMethod {
  get('get'),
  put('put'),
  post('post'),
  delete('delete'),
  options('options'),
  head('head'),
  patch('patch'),
  trace('trace');

  const HttpMethod(this.value);

  final String value;

  @override
  String toString() => value;
}

@JsonEnum(alwaysCreate: true, valueField: 'value')
enum JsonSchemaFormat {
  email('email'),
  password('password');

  const JsonSchemaFormat(this.value);

  final String value;
}

@JsonEnum(alwaysCreate: true, valueField: 'value')
enum JsonSchemaTypeValue {
  nil('null'),
  boolean('bool'),
  object('object'),
  array('array'),
  number('number'),
  integer('integer'),
  string('string');

  const JsonSchemaTypeValue(this.value);

  final String value;
}

class JsonSchemaTypeJsonConverter
    extends JsonConverter<JsonSchemaType?, dynamic> {
  const JsonSchemaTypeJsonConverter();

  @override
  JsonSchemaType? fromJson(dynamic json) {
    JsonSchemaTypeValue? findValue(String value) =>
        JsonSchemaTypeValue.values.where((e) => e.value == value).firstOrNull;

    final types = switch (json) {
      final String value => findValue(value),
      final List<String> value =>
        value.map(findValue).where((e) => e != null).toList(),
      _ => null,
    };

    return switch (types) {
      final List<JsonSchemaTypeValue> types => JsonSchemaMultiType(types),
      final JsonSchemaTypeValue type => JsonSchemaOneType(type),
      _ => null,
    };
  }

  @override
  dynamic toJson(JsonSchemaType? object) {
    return switch (object) {
      final JsonSchemaOneType type => type.type.value,
      final JsonSchemaMultiType type => type.types.map((e) => e.value).toList(),
      _ => null,
    };
  }
}

sealed class JsonSchemaType {
  const JsonSchemaType._();
}

class JsonSchemaOneType extends JsonSchemaType {
  const JsonSchemaOneType(this.type) : super._();

  final JsonSchemaTypeValue type;
}

class JsonSchemaMultiType extends JsonSchemaType {
  const JsonSchemaMultiType(this.types) : super._();

  final List<JsonSchemaTypeValue> types;
}
