import 'package:json_annotation/json_annotation.dart';
import 'package:tio/tio.dart';

import '../entities.dart';
import '../internal.dart';

part 'media_type.g.dart';

@JsonSerializable(createToJson: false)
class MediaTypeObject {
  const MediaTypeObject({this.schema});

  factory MediaTypeObject.fromJson(JSON json) =>
      _$MediaTypeObjectFromJson(json);

  final SchemaObject? schema;

  /// @TODO example, examples, encoding
}
