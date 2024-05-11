import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:tio/tio.dart';

import '../utils.dart';

class TioOpenApiClientGenerator
    extends GeneratorForAnnotation<TioOpenApiClient> {
  @override
  FutureOr<String?> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      return null;
    }

    final $annotation = TioOpenApiClient(
      path: annotation.read('path').stringValue,
    );

    return _generate(element, $annotation, buildStep);
  }

  FutureOr<String> _generate(
    ClassElement element,
    TioOpenApiClient annotation,
    BuildStep buildStep,
  ) {
    final openapi = loadOpenApi(annotation.path);
    return 'var i = 1;';
  }
}
