// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationObject _$OperationObjectFromJson(Map<String, dynamic> json) =>
    OperationObject(
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      responses: _$JsonConverterFromJson<Map<String, dynamic>, ResponsesObject>(
          json['responses'], const ResponsesObjectJsonConverter().fromJson),
    );

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
