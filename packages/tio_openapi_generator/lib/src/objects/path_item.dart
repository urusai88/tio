import 'package:json_annotation/json_annotation.dart';

import '../enums.dart';
import '../internal.dart';
import '../objects.dart';

part 'path_item.g.dart';

typedef OperationMapEntry = MapEntry<HttpMethod, OperationObject>;

@JsonSerializable(createToJson: false)
class PathItemObject {
  const PathItemObject({
    // this.$ref,
    // this.summary,
    // this.description,
    this.get,
    this.put,
    this.post,
    this.delete,
    this.options,
    this.head,
    this.patch,
    this.trace,
    this.parameters,
  });

  factory PathItemObject.fromJson(JSON json) => _$PathItemObjectFromJson(json);

  // final String? $ref;
  // final String? summary;
  // final String? description;
  final OperationObject? get;
  final OperationObject? put;
  final OperationObject? post;
  final OperationObject? delete;
  final OperationObject? options;
  final OperationObject? head;
  final OperationObject? patch;
  final OperationObject? trace;

  final List<ParameterObject>? parameters;

  List<OperationMapEntry> get operations => [
        if (get != null) MapEntry(HttpMethod.get, get!),
        if (put != null) MapEntry(HttpMethod.put, put!),
        if (post != null) MapEntry(HttpMethod.post, post!),
        if (delete != null) MapEntry(HttpMethod.delete, delete!),
        if (options != null) MapEntry(HttpMethod.options, options!),
        if (head != null) MapEntry(HttpMethod.head, head!),
        if (patch != null) MapEntry(HttpMethod.patch, patch!),
        if (trace != null) MapEntry(HttpMethod.trace, trace!),
      ];

// @TODO servers, parameters
}
