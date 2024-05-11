import 'dart:async';

import 'package:code_builder/code_builder.dart';
import 'package:tio/tio.dart';

import '../builders.dart';
import '../entities.dart';
import '../extensions/string_x.dart';
import 'base_components_generator.dart';

class TioOpenApiSchemasGenerator extends TioOpenApiBaseComponentsGenerator {
  const TioOpenApiSchemasGenerator();

  @override
  String get suffix => 'schemas';

  @override
  FutureOr<Stream<String>> generate({
    required LibraryReader libraryReader,
    required TioOpenApiClient annotation,
    required OpenApiObject config,
  }) async* {
    if (config.components == null) {
      return;
    }

    // for (final schemaEntry in config.components!.schemas.entries) {
    //   final name = schemaEntry.key;
    //   final schema = schemaEntry.value;
    //   final schemaName = '${name}Schema';
    //
    //   Spec expression(String code) => (TypeDefBuilder()
    //         ..name = schemaName
    //         ..definition = CodeExpression(Code(code)))
    //       .build();
    //
    //   Spec spec;
    //
    //   switch (schema.type) {
    //     case JsonSchemaObjectType _:
    //       final classBuilder = ClassBuilder()..name = schemaName;
    //       final constructorBuilder = ConstructorBuilder()
    //         ..update((b) => b.constant = true);
    //
    //       if (schema.properties != null) {
    //         for (final propertyEntry in schema.properties!.entries) {
    //           final propertyName = propertyEntry.key.camel;
    //           final propertySchema = propertyEntry.value;
    //
    //           final field = Field(
    //             (b) => b
    //               ..name = propertyName
    //               ..type = _buildPropertyTypeDef(propertySchema)
    //               ..modifier = FieldModifier.final$,
    //           );
    //           final parameter = Parameter(
    //             (b) => b
    //               ..name = propertyName
    //               ..named = true
    //               ..toThis = true
    //               ..required = true,
    //           );
    //
    //           constructorBuilder
    //               .update((b) => b.optionalParameters.add(parameter));
    //           classBuilder.update((b) => b.fields.add(field));
    //         }
    //       }
    //
    //       classBuilder.update(
    //         (b) => b.constructors.add(constructorBuilder.build()),
    //       );
    //       spec = classBuilder.build();
    //     case JsonSchemaArrayType _:
    //       if (schema.items != null) {}
    //       spec = expression('List');
    //     case final JsonSchemaPrimitiveType type:
    //       spec = _buildPrimitiveTypeDef(schemaName, type);
    //   }
    //
    //   yield spec.accept(emitter).toString();
    // }
  }

  // Type _primitiveType(JsonSchemaPrimitiveType type) => type.dartType;
  //
  // Spec _buildPrimitiveTypeDef(String name, JsonSchemaPrimitiveType type) {
  //   return TypeDef(
  //     (b) => b
  //       ..name = name
  //       ..definition =
  //           TypeReference((b) => b..symbol = _primitiveType(type).toString()),
  //   );
  // }
  //
  // Reference _buildPropertyTypeDef(SchemaObject schema) {
  //   switch (schema.type) {
  //     case final JsonSchemaObjectType _:
  //       if (schema.properties == null) {
  //         return TypeReference((b) => b..symbol = (Object).toString());
  //       }
  //
  //       final b = RecordTypeBuilder();
  //
  //       for (final MapEntry(key: propertyName, value: propertySchema)
  //           in schema.properties!.entries) {}
  //       return b.build();
  //     case final JsonSchemaArrayType _:
  //       return TypeReference(
  //         (b) => b
  //           ..symbol = _primitiveType(const JsonSchemaPrimitiveType.string())
  //               .toString(),
  //       );
  //     case final JsonSchemaPrimitiveType type:
  //       return TypeReference(
  //         (b) => b..symbol = _primitiveType(type).toString(),
  //       );
  //     case null:
  //       return TypeReference((b) => b..symbol = 'Null');
  //   }
  // }
}
