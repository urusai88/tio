import '../enums.dart';
import '../objects.dart';

class Endpoint {
  const Endpoint({
    required this.method,
    required this.path,
    required this.pathItem,
    required this.operation,
  });

  final HttpMethod method;
  final String path;
  final PathItemObject pathItem;
  final OperationObject operation;

  List<String> get parts => path.substring(1).split('/');

  String get debugLabel => '$method $path';

  SchemaObject? get returnSchema => operation.responses?.values.values
      .firstOrNull?.content?.values.firstOrNull?.schema;

  JsonSchemaType? get returnType => returnSchema?.type;
}
