// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openapi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenApiObject _$OpenApiObjectFromJson(Map<String, dynamic> json) =>
    OpenApiObject(
      openapi: json['openapi'] as String,
      components: json['components'] == null
          ? null
          : ComponentsObject.fromJson(
              json['components'] as Map<String, dynamic>),
      paths: (json['paths'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, PathItemObject.fromJson(e as Map<String, dynamic>)),
      ),
    );
