import 'package:json_annotation/json_annotation.dart';

import 'internal.dart';

part 'yaml.g.dart';

typedef TioOpenApiConfigs = StringMap<TioOpenApiConfigItem>;

@JsonSerializable(explicitToJson: true)
class TioOpenApiConfig {
  const TioOpenApiConfig({required this.configs});

  const TioOpenApiConfig.defaults()
      : configs = const {
          'main': TioOpenApiConfigItem(
            openapi: 'openapi.yaml',
          ),
        };

  factory TioOpenApiConfig.fromJson(JSON json) =>
      _$TioOpenApiConfigFromJson(json);

  final TioOpenApiConfigs configs;

  JSON toJson() => _$TioOpenApiConfigToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TioOpenApiConfigItem {
  const TioOpenApiConfigItem({
    required this.openapi,
  });

  factory TioOpenApiConfigItem.fromJson(JSON json) =>
      _$TioOpenApiConfigItemFromJson(json);

  final String openapi;

  JSON toJson() => _$TioOpenApiConfigItemToJson(this);
}
