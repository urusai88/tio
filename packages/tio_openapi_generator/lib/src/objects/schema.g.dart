// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchemaObject _$SchemaObjectFromJson(Map<String, dynamic> json) => SchemaObject(
      $id: json[r'$id'] as String?,
      $ref: json[r'$ref'] as String?,
      type: const JsonSchemaTypeJsonConverter().fromJson(json['type']),
      format: $enumDecodeNullable(_$JsonSchemaFormatEnumMap, json['format']),
      properties: (json['properties'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, SchemaObject.fromJson(e as Map<String, dynamic>)),
      ),
      minLength: (json['minLength'] as num?)?.toInt(),
      maxLength: (json['maxLength'] as num?)?.toInt(),
      minimum: (json['minimum'] as num?)?.toInt(),
      maximum: (json['maximum'] as num?)?.toInt(),
      pattern: json['pattern'] as String?,
      uniqueItems: json['uniqueItems'] as bool?,
      items: json['items'] == null
          ? null
          : SchemaObject.fromJson(json['items'] as Map<String, dynamic>),
    );

const _$JsonSchemaFormatEnumMap = {
  JsonSchemaFormat.email: 'email',
  JsonSchemaFormat.password: 'password',
};
