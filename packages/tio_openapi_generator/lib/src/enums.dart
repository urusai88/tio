import 'package:json_annotation/json_annotation.dart';

// @JsonEnum(valueField: 'value')
// enum JsonSchemaType {
//   nil('null'),
//   boolean('boolean'),
//   object('object'),
//   array('array'),
//   number('number'),
//   integer('integer'),
//   string('string');
//
//   const JsonSchemaType(this.value);
//
//   final String value;
// }

@JsonEnum(valueField: 'value')
enum JsonSchemaFormat {
  email('email'),
  password('password');

  const JsonSchemaFormat(this.value);

  final String value;
}
