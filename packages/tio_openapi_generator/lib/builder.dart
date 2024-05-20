import 'package:build/build.dart';

import 'src/builders/openapi_client_builder.dart';
import 'src/generators.dart';
import 'src/generators/schemas.dart';

Builder tioOpenApiClientBuilder(BuilderOptions options) {
  return TioOpenApiClientBuilder(
    options: options,
    componentsGenerators: const [
      SchemasGenerator(),
      PathsGenerator(),
      // TioOpenApiSchemasGenerator(),
    ],
  );
}
