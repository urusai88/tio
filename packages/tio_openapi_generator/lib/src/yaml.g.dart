// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yaml.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TioOpenApiConfig _$TioOpenApiConfigFromJson(Map<String, dynamic> json) =>
    TioOpenApiConfig(
      configs: (json['configs'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, TioOpenApiConfigItem.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$TioOpenApiConfigToJson(TioOpenApiConfig instance) =>
    <String, dynamic>{
      'configs': instance.configs.map((k, e) => MapEntry(k, e.toJson())),
    };

TioOpenApiConfigItem _$TioOpenApiConfigItemFromJson(
        Map<String, dynamic> json) =>
    TioOpenApiConfigItem(
      openapi: json['openapi'] as String,
    );

Map<String, dynamic> _$TioOpenApiConfigItemToJson(
        TioOpenApiConfigItem instance) =>
    <String, dynamic>{
      'openapi': instance.openapi,
    };
