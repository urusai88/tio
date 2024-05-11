import '../utils.dart';
import 'json_schema_type.dart';

class TioOpenApiPathItem {
  const TioOpenApiPathItem({required this.path, this.tags, this.returnType});

  final String path;
  final List<String>? tags;
  final JsonSchemaType? returnType;
}

abstract class TioOpenApiResolver {
  const TioOpenApiResolver();

  String resolveApiName({required TioOpenApiPathItem pathItem});

  String resolveMethodName({required TioOpenApiPathItem pathItem});
}

class TioOpenApiDefaultResolver extends TioOpenApiResolver {
  const TioOpenApiDefaultResolver({
    this.defaultApiName = 'others',
    this.upperCase = true,
  });

  final String defaultApiName;
  final bool upperCase;

  @override
  String resolveApiName({required TioOpenApiPathItem pathItem}) {
    String? name;
    if (pathItem.tags?.isNotEmpty ?? false) {
      name = pathItem.tags!.first;
    } else {
      name = defaultApiName;
    }
    return TioUtils.upperCaseFirst(name);
  }

  @override
  String resolveMethodName({required TioOpenApiPathItem pathItem}) {
    return 'poof';
  }
}
