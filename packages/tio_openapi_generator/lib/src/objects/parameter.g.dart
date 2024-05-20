// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParameterObject _$ParameterObjectFromJson(Map<String, dynamic> json) =>
    ParameterObject(
      name: json['name'] as String,
      in$: $enumDecode(_$ParameterInEnumMap, json['in']),
      description: json['description'] as String?,
      required: json['required'] as bool?,
      deprecated: json['deprecated'] as bool?,
      schema: json['schema'] == null
          ? null
          : SchemaObject.fromJson(json['schema'] as Map<String, dynamic>),
    );

const _$ParameterInEnumMap = {
  ParameterIn.query: 'query',
  ParameterIn.header: 'headers',
  ParameterIn.path: 'path',
  ParameterIn.cookie: 'cookie',
};
