import 'package:json_annotation/json_annotation.dart';
import 'package:tio/tio.dart';

import '../entities.dart';
import '../internal.dart';

part 'operation.g.dart';

@JsonSerializable(createToJson: false)
@ResponsesObjectJsonConverter()
class OperationObject {
  const OperationObject({this.tags, this.responses});

  factory OperationObject.fromJson(JSON json) =>
      _$OperationObjectFromJson(json);

  final List<String>? tags;
  // final String? summary;
  // final String? description;

  /// @TODO summary, description, externalDocs, operationId, parameters,
  /// requestBody
  final ResponsesObject? responses;
}
