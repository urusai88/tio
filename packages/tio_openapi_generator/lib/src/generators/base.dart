import '../objects.dart' show OpenApiObject;
import '../schemas.dart';

export 'dart:async' show FutureOr;

export '../objects.dart' show OpenApiObject;
export '../schemas.dart';
export 'endpoint.dart';
export 'resolvers.dart';

abstract class BaseComponentsGenerator {
  const BaseComponentsGenerator();

  String get suffix;

  Iterable<String> generate({
    required OpenApiObject config,
    required Schemas schemas,
  });
}
