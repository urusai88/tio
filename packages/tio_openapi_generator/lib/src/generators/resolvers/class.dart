import 'package:meta/meta.dart';
import 'package:tio/tio.dart';

import '../../generators.dart';

@immutable
class ClassName {
  const ClassName(this.name, {required this.usedDefault});

  final String name;
  final bool usedDefault;

  String get normalized => TioUtils.upperCamel(name);

  bool equals(ClassName other) => normalized == other.normalized;

  @override
  int get hashCode => normalized.hashCode;

  @override
  bool operator ==(Object other) => other is ClassName && equals(other);

  @override
  String toString() => normalized;
}

abstract class ClassResolver {
  const ClassResolver({this.defaultClassName = 'others'});

  final String defaultClassName;

  String? firstTag(Endpoint endpoint) => endpoint.operation.tags?.firstOrNull;

  ClassName resolve({required Endpoint endpoint}) =>
      ClassName(defaultClassName, usedDefault: true);
}

class FirstTagClassResolver extends ClassResolver {
  const FirstTagClassResolver({super.defaultClassName});

  @override
  ClassName resolve({required Endpoint endpoint}) {
    final name = firstTag(endpoint);
    if (name == null) {
      return super.resolve(endpoint: endpoint);
    }
    return ClassName(name, usedDefault: false);
  }
}
