import 'package:json_annotation/json_annotation.dart';

import 'objects.dart';

typedef StringMap<T> = Map<String, T>;
typedef JSON = StringMap<dynamic>;

class ResponsesObjectJsonConverter
    extends JsonConverter<ResponsesObject, JSON> {
  const ResponsesObjectJsonConverter();

  @override
  ResponsesObject fromJson(Map<dynamic, dynamic> json) {
    final result = <ResponsesObjectKey, ResponseObject>{};
    for (final entry in json.entries) {
      final code =
          entry.key is int ? entry.key : int.tryParse(entry.key as String);
      final response = ResponseObject.fromJson(entry.value as JSON);
      ResponsesObjectKey? key;
      if (code is int) {
        key = ResponsesCodeObjectKey(code);
      } else if (entry.key == ResponsesDefaultObjectKey.key) {
        key = const ResponsesDefaultObjectKey();
      }
      if (key != null) {
        result[key] = response;
      }
    }
    return ResponsesObject(result);
  }

  @override
  JSON toJson(ResponsesObject object) {
    throw UnimplementedError();
  }
}

sealed class ResponsesObjectKey {
  const ResponsesObjectKey();
}

class ResponsesDefaultObjectKey extends ResponsesObjectKey {
  const ResponsesDefaultObjectKey();

  static const key = 'default';
}

class ResponsesCodeObjectKey extends ResponsesObjectKey {
  const ResponsesCodeObjectKey(this.code);

  final int code;
}

class ResponsesObject {
  const ResponsesObject(this.values);

  final Map<ResponsesObjectKey, ResponseObject> values;
}
