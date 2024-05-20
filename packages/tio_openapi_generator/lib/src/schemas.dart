import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:tio/tio.dart';

import 'builders.dart';
import 'enums.dart';
import 'objects/schema.dart';

class Schemas {
  const Schemas({required this.schemas});

  static final componentsRegExp =
      RegExp(r'^#\/components\/schemas\/([\w_$]+)$');

  final Map<Uri, SchemaObject> schemas;

  String? getComponentSchemaName(Uri uri) {
    return componentsRegExp.firstMatch('$uri')?.group(1);
  }

  Map<Uri, SchemaObject> get componentSchemas =>
      Map<Uri, SchemaObject>.fromEntries(
        schemas.entries.where((e) => componentsRegExp.hasMatch('${e.key}')),
      );

  Map<Uri, SchemaObject> get componentSchemasWithAliases {
    final tmp = Map<Uri, SchemaObject>.fromEntries(
      schemas.entries.where((e) => componentsRegExp.hasMatch('${e.key}')),
    );
    final $ids = tmp.entries.map((e) => e.value.$id).whereNotNull();
    final tmp2 = Map<Uri, SchemaObject>.fromEntries(
        schemas.entries.where((e) => $ids.contains(e.key)));

    return <Uri, SchemaObject>{...tmp, ...tmp2};
  }

  String resolveSchemaName(SchemaObject schemaObject, Uri uri) {
    if (uri.hasFragment) {
      return '${TioUtils.upperCamel(uri.fragment.split('/').last)}Schema';
    } else {
      return '$uri';
    }
  }

  String resolve({required SchemaObject? schema}) {
    if (schema == null) {
      return 'void';
    }

    if ((schema.$ref != null && schema.$ref == schema.$id) ||
        (schema.items?.$ref != null && schema.items!.$ref == schema.$id)) {
      throw ArgumentError('\$ref(${schema.$ref}) == \$id(${schema.$id})');
    }

    final $ref = schema.$ref ?? schema.items?.$ref;

    final targetSchema = schemas[$ref];
    final actualSchema = targetSchema ?? schema;
    final isComponentSchema = componentSchemasWithAliases.containsKey($ref);
    final typeValue = (schema.type as JsonSchemaOneType?)?.type;
    final actualTypeValue = (actualSchema.type as JsonSchemaOneType?)!.type;

    return switch (typeValue ?? actualTypeValue) {
      JsonSchemaTypeValue.boolean => '$bool',
      JsonSchemaTypeValue.object => isComponentSchema
          ? resolveSchemaName(actualSchema, $ref!)
          : createRecord(actualSchema),
      JsonSchemaTypeValue.array =>
        'List<${isComponentSchema ? resolveSchemaName(actualSchema, $ref!) : createRecord(actualSchema)}>',
      JsonSchemaTypeValue.number => '$num',
      JsonSchemaTypeValue.integer => '$int',
      JsonSchemaTypeValue.string => '$String',
      _ => '$dynamic',
    };
  }

  String createRecord(SchemaObject schemaObject) {
    final record = RecordType((b) {
      if (schemaObject.properties == null) {
        return;
      }

      for (final MapEntry(key: name, value: property)
          in schemaObject.properties!.entries) {
        b.namedFieldTypes.update((b) {
          b[name] = refer(resolve(schema: property));
        });
      }
    });

    return '${record.accept(emitter)}';
  }
}
