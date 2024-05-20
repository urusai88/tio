// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PathItemObject _$PathItemObjectFromJson(Map<String, dynamic> json) =>
    PathItemObject(
      get: json['get'] == null
          ? null
          : OperationObject.fromJson(json['get'] as Map<String, dynamic>),
      put: json['put'] == null
          ? null
          : OperationObject.fromJson(json['put'] as Map<String, dynamic>),
      post: json['post'] == null
          ? null
          : OperationObject.fromJson(json['post'] as Map<String, dynamic>),
      delete: json['delete'] == null
          ? null
          : OperationObject.fromJson(json['delete'] as Map<String, dynamic>),
      options: json['options'] == null
          ? null
          : OperationObject.fromJson(json['options'] as Map<String, dynamic>),
      head: json['head'] == null
          ? null
          : OperationObject.fromJson(json['head'] as Map<String, dynamic>),
      patch: json['patch'] == null
          ? null
          : OperationObject.fromJson(json['patch'] as Map<String, dynamic>),
      trace: json['trace'] == null
          ? null
          : OperationObject.fromJson(json['trace'] as Map<String, dynamic>),
      parameters: (json['parameters'] as List<dynamic>?)
          ?.map((e) => ParameterObject.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
