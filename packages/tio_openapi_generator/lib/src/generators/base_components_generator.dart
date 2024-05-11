import 'dart:async' show FutureOr;

import 'package:source_gen/source_gen.dart' show LibraryReader;
import 'package:tio/tio.dart' show TioOpenApiClient;

import '../entities.dart' show OpenApiObject;

export 'dart:async' show FutureOr;

export 'package:source_gen/source_gen.dart' show LibraryReader;
export 'package:tio/tio.dart' show TioOpenApiClient;

export '../entities.dart' show OpenApiObject;

abstract class TioOpenApiBaseComponentsGenerator {
  const TioOpenApiBaseComponentsGenerator();

  String get suffix;

  FutureOr<Stream<String>> generate({
    required LibraryReader libraryReader,
    required TioOpenApiClient annotation,
    required OpenApiObject config,
  });
}
