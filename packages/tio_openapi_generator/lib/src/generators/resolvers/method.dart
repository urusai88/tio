import 'package:collection/collection.dart';

import '../../enums.dart';
import '../../generators.dart';

abstract class MethodResolver {
  const MethodResolver();

  String? resolve({required Endpoint endpoint, required ClassName className}) =>
      null;
}

class ChainMethodResolver extends MethodResolver {
  const ChainMethodResolver({required this.resolvers});

  final List<MethodResolver> resolvers;

  @override
  String? resolve({required Endpoint endpoint, required ClassName className}) =>
      resolvers
          .map((e) => e.resolve(endpoint: endpoint, className: className))
          .whereNotNull()
          .firstOrNull;
}

class PathMethodResolver extends MethodResolver {
  const PathMethodResolver();

  @override
  String? resolve({required Endpoint endpoint, required ClassName className}) =>
      endpoint.parts.takeWhile((value) => !value.startsWith('{')).join();
}

class CrudMethodResolver extends MethodResolver {
  const CrudMethodResolver({
    this.listName = _listName,
    this.getName = _getName,
    this.createName = _createName,
    this.updateName = _updateName,
    this.deleteName = _deleteName,
  });

  static const _listName = 'list';
  static const _getName = 'get';
  static const _createName = 'create';
  static const _updateName = 'update';
  static const _deleteName = 'delete';

  final String listName;
  final String getName;
  final String createName;
  final String updateName;
  final String deleteName;

  bool compareNames(String a, String b) {
    a = a.toLowerCase();
    b = b.toLowerCase();

    List<String> makeVariants(String value) =>
        [value, '${value}s', '${value}es'];

    final variantsA = makeVariants(a);
    final variantsB = makeVariants(b);

    for (final v1 in variantsA) {
      for (final v2 in variantsB) {
        if (v1 == v2) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  String? resolve({required Endpoint endpoint, required ClassName className}) {
    final first = endpoint.parts.elementAtOrNull(0);
    final second = endpoint.parts.elementAtOrNull(1);
    if (className.usedDefault || first == null) {
      return null;
    }
    if (!compareNames(className.normalized, first)) {
      return null;
    }
    if (second != null) {
      return switch (endpoint.method) {
        HttpMethod.get => getName,
        HttpMethod.post || HttpMethod.put => updateName,
        HttpMethod.delete => deleteName,
        _ => null,
      };
    }
    return switch (endpoint.returnType) {
      final JsonSchemaOneType type =>
        type.type == JsonSchemaTypeValue.array ? listName : getName,
      _ => null,
    };
  }
}
