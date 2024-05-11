import 'package:build/build.dart';

import 'src/builders/openapi_client_builder.dart';
import 'src/generators.dart';

Builder tioOpenApiClientBuilder(BuilderOptions options) {
  return TioOpenApiClientBuilder(
    componentsGenerators: const [
      TioOpenApiPathsGenerator(),
      // TioOpenApiSchemasGenerator(),
    ],
  );
}
