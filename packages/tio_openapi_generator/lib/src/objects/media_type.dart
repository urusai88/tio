import 'package:json_annotation/json_annotation.dart';

import '../internal.dart';
import '../objects.dart';

part 'media_type.g.dart';

@JsonSerializable(createToJson: false)
class MediaTypeObject {
  const MediaTypeObject({this.schema});

  factory MediaTypeObject.fromJson(JSON json) =>
      _$MediaTypeObjectFromJson(json);

  final SchemaObject? schema;

  /// @TODO example, examples, encoding
}
