import 'package:code_builder/code_builder.dart';
import 'package:tio/tio.dart';

import 'base_components_generator.dart';

class TioOpenApiPathsGenerator extends TioOpenApiBaseComponentsGenerator {
  const TioOpenApiPathsGenerator({
    this.apiResolver = const TioOpenApiDefaultResolver(),
  });

  final TioOpenApiResolver apiResolver;

  @override
  String get suffix => 'paths';

  @override
  FutureOr<Stream<String>> generate({
    required LibraryReader libraryReader,
    required TioOpenApiClient annotation,
    required OpenApiObject config,
  }) async* {
    if (config.paths == null) {
      return;
    }

    final apis = <String, ClassBuilder>{};
    for (final MapEntry(key: path, value: pathItem) in config.paths!.entries) {
      final operations = pathItem.operations;
      for (final MapEntry(key: method, value: operation) in operations) {
        final response = operation.responses?.values.entries.first;
        final mediaQuery = response?.value.content?.values.first;
        if (mediaQuery == null) {
          continue;
        }

        final pathItemInfo = TioOpenApiPathItem(
          path: path,
          tags: operation.tags,
          returnType: mediaQuery.schema?.type,
        );

        final apiName = apiResolver.resolveApiName(
          pathItem: pathItemInfo,
        );

        print(apiName);
      }

      // final schema =
      //     responses.values.values.first.content!.values.first.schema!;
      // final pathItemInfo = TioOpenApiPathItem(
      //   path: path,
      //   tags: getOperation.tags,
      //   returnType: schema.type!,
      // );
    }
  }
}
