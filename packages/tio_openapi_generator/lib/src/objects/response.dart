import 'package:json_annotation/json_annotation.dart';
import 'package:tio/tio.dart';

import '../entities.dart';
import '../internal.dart';

part 'response.g.dart';

@JsonSerializable(createToJson: false)
class ResponseObject {
  const ResponseObject({required this.description, this.content});

  factory ResponseObject.fromJson(JSON json) => _$ResponseObjectFromJson(json);

  /// @TODO headers, links
  final String description;
  final StringMap<MediaTypeObject>? content;
}
