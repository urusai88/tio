import '../generators.dart';

class SchemasGenerator extends BaseComponentsGenerator {
  const SchemasGenerator();

  @override
  String get suffix => 'suffix';

  @override
  Iterable<String> generate({
    required OpenApiObject config,
    required Schemas schemas,
  }) sync* {
    for (final MapEntry(key: uri, value: schemaItem)
        in schemas.componentSchemas.entries) {
      final schemaName = schemas.resolveSchemaName(schemaItem, uri);
    }
  }
}
