import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';

import '../generators.dart';
import '../objects.dart';
import '../utils.dart';
import '../yaml.dart';

final emitter = DartEmitter(orderDirectives: true, useNullSafetySyntax: true);
final formatter = DartFormatter();

class TioOpenApiClientBuilder implements Builder {
  TioOpenApiClientBuilder({
    required BuilderOptions options,
    required this.componentsGenerators,
  })  : options = TioOpenApiConfig.fromJson(options.config),
        buildExtensions = {
          '{{name}}.yaml': [
            for (final generator in componentsGenerators)
              'lib/tio/{{name}}.${generator.suffix}.g.dart',
          ],
        };

  static final logger = Logger('TioOpenApiClientBuilder');

  final TioOpenApiConfig options;

  final List<BaseComponentsGenerator> componentsGenerators;

  @override
  final Map<String, List<String>> buildExtensions;

  Schemas createSchemas(OpenApiObject openApi) {
    final componentSchemas = openApi.components?.schemas?.values
        .map((e) => e.nestedSchemas())
        .expand((e) => e)
        .where((e) => e.isUrn || e.isId)
        .map((e) => MapEntry(e.$id!, e));
    final componentAliases =
        openApi.components?.schemas?.entries.map<MapEntry<Uri, SchemaObject>>(
      (e) => MapEntry(Uri.parse('#/components/schemas/${e.key}'), e.value),
    );

    // final otherSchemas = [
    //   openApi.paths?.values
    //       .map((e) => e.operations)
    //       .expand((e) => e)
    //       .map((e) => e.value.responses)
    //       .whereNotNull()
    //       .map((e) => e.values.values)
    //       .expand((e) => e)
    //       .map((e) => e.content?.values)
    //       .whereNotNull()
    //       .expand((e) => e),
    // ];

    final entries = [
      if (componentSchemas != null) ...componentSchemas,
      if (componentAliases != null) ...componentAliases,
    ];
    final schemas = Map<Uri, SchemaObject>.fromEntries(entries);

    return Schemas(schemas: schemas);
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final outputs = buildStep.allowedOutputs;
    final contents = await buildStep.readAsString(inputId);
    final json = yamlToJson(loadYaml(contents));
    final config = OpenApiObject.fromJson(json);
    final schemas = createSchemas(config);

    for (final generator in componentsGenerators) {
      final output = generator
          .generate(config: config, schemas: schemas)
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .join('\n');

      if (output.isNotEmpty) {
        await buildStep.writeAsString(
          outputs.firstWhere((e) => e.path.contains(generator.suffix)),
          formatter.format(output),
        );
      }
    }
  }
}
