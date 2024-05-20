import 'package:code_builder/code_builder.dart';
import 'package:logging/logging.dart';
import 'package:tio/tio.dart';

import '../builders.dart';
import '../objects.dart';
import 'base.dart';

class TioOpenApiBuilders {
  TioOpenApiBuilders()
      : interfaceBuilder = ClassBuilder()
          ..update(
            (b) => b
              ..abstract = true
              ..modifier = ClassModifier.interface
              ..constructors.update(
                (b) => b..add(Constructor((b) => b..constant = true)),
              ),
          ),
        implementationBuilder = ClassBuilder()
          ..update(
            (b) => b
              ..constructors.update(
                (b) => b..add(Constructor((b) => b..constant = true)),
              ),
          );

  final ClassBuilder interfaceBuilder;
  final ClassBuilder implementationBuilder;

  Iterable<Spec> get code =>
      [interfaceBuilder.build(), implementationBuilder.build()];

  void setName(ClassName className) {
    final normalized = className.normalized;
    final name1 = '${className.normalized}Api';
    final name2 = '${className.normalized}HttpApi';

    interfaceBuilder.update((b) => b.name = name1);
    implementationBuilder.update(
      (b) => b
        ..name = name2
        ..implements.update((b) => b.add(refer(name1))),
    );
  }
}

class PathsGenerator extends BaseComponentsGenerator {
  const PathsGenerator();

  static final logger = Logger('PathsGenerator');

  @override
  String get suffix => 'paths';

  /// @TODO
  static const classResolver = FirstTagClassResolver();
  static const methodResolver = ChainMethodResolver(
    resolvers: [
      CrudMethodResolver(),
      PathMethodResolver(),
    ],
  );

  @override
  Iterable<String> generate({
    required OpenApiObject config,
    required Schemas schemas,
  }) sync* {
    return;
    if (config.paths == null) {
      return;
    }

    final builders = <ClassName, TioOpenApiBuilders>{};
    final endpoints = config.paths!.entries.map((pathEntry) {
      return pathEntry.value.operations.map(
        (operationsEntry) => Endpoint(
          method: operationsEntry.key,
          path: pathEntry.key,
          pathItem: pathEntry.value,
          operation: operationsEntry.value,
        ),
      );
    }).fold(const <Endpoint>[], (p, e) => [...p, ...e]);

    for (final endpoint in endpoints) {
      final className = classResolver.resolve(endpoint: endpoint);
      final methodName =
          methodResolver.resolve(endpoint: endpoint, className: className);
      if (methodName == null) {
        logger.warning(
          'Could not resolve method name for ${endpoint.debugLabel}. Skip.',
        );
        continue;
      }

      _buildMethod(
        schemas: schemas,
        endpoint: endpoint,
        builders: builders.putIfAbsent(className, TioOpenApiBuilders.new),
        methodName: methodName,
      );
    }

    for (final MapEntry(key: className, value: builders) in builders.entries) {
      builders.setName(className);
      for (final code in builders.code) {
        yield '${code.accept(emitter)}';
      }
    }
  }

  void _buildMethod({
    required Schemas schemas,
    required Endpoint endpoint,
    required TioOpenApiBuilders builders,
    required String methodName,
  }) {
    final method1 = Method((b) {
      b
        ..name = methodName
        ..returns = TypeReference(
          (b) => b
            ..symbol = 'Future'
            ..types.add(
              refer(schemas.resolve(schema: endpoint.returnSchema)),
            ),
        );

      if (endpoint.pathItem.parameters != null) {
        for (final parameter in endpoint.pathItem.parameters!) {
          b.optionalParameters.add(
            Parameter(
              (b) {
                b
                  ..named = true
                  ..required = parameter.in$ == ParameterIn.path ||
                      (parameter.required ?? false)
                  ..name = TioUtils.lowerCamel(parameter.name);

                b.type = refer(
                  schemas.resolve(schema: parameter.schema),
                );
              },
            ),
          );
        }
      }
    });

    final method2 = method1.toBuilder()
      ..update((b) {
        b.annotations.update((b) => b.add(refer('override')));
      });

    builders.interfaceBuilder
        .update((b) => b.methods.update((b) => b.add(method1)));
    builders.implementationBuilder
        .update((b) => b.methods.update((b) => b.add(method2.build())));
  }
}
