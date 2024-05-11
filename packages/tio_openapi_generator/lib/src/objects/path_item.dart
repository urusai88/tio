import 'package:json_annotation/json_annotation.dart';
import 'package:tio/tio.dart';

import '../entities.dart';

part 'path_item.g.dart';

typedef OperationMapEntry = MapEntry<String, OperationObject>;

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

  List<OperationMapEntry> get operations => [
        if (get != null) MapEntry('GET', get!),
        if (put != null) MapEntry('PUT', put!),
        if (post != null) MapEntry('POST', post!),
        if (delete != null) MapEntry('DELETE', delete!),
        if (options != null) MapEntry('OPTIONS', options!),
        if (head != null) MapEntry('HEAD', head!),
        if (patch != null) MapEntry('PATCH', patch!),
        if (trace != null) MapEntry('TRACE', trace!),
      ];

// @TODO servers, parameters
}
