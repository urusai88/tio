import 'package:meta/meta_meta.dart';

@Target({TargetKind.classType})
class TioOpenApiClient {
  const TioOpenApiClient({required this.path});

  final String path;
}

@Target({TargetKind.classType})
class TioOpenApiSchema {
  const TioOpenApiSchema(this.name);

  final String name;
}
