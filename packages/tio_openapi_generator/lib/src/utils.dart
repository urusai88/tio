import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

import 'internal.dart';
import 'objects.dart';

const _yamlExtension = '.yaml';
const _jsonExtension = '.json';
const _supportVersion = '3.1.0';

const _invalidMessage = 'openapi file contents is not JSON or YAML object';

dynamic yamlToDart(dynamic value) {
  return switch (value) {
    final YamlMap node => JSON.fromEntries(
        node.entries.map((e) => MapEntry(e.key as String, yamlToDart(e.value))),
      ),
    final YamlList node => node.map(yamlToDart).toList(),
    _ => value,
  };
}

JSON yamlToJson(dynamic value) => yamlToDart(value) as JSON;

OpenApiObject loadOpenApi(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw Exception('openapi file ${file.path} does not exists');
  }
  final contents = file.readAsStringSync();
  final isYaml = file.path.endsWith(_yamlExtension);
  final isJson = file.path.endsWith(_jsonExtension);

  try {
    var tmp = isJson ? json.decode(contents) : loadYaml(contents);
    if (tmp is YamlMap) {
      tmp = yamlToDart(tmp);
    }
    if (tmp is! Map) {
      throw Exception(_invalidMessage);
    }
    tmp = JSON.from(tmp);
    if (tmp is! JSON) {
      throw Exception(_invalidMessage);
    }
    return OpenApiObject.fromJson(tmp);
  } catch (e, s) {
    throw Exception('$_invalidMessage\ninner: $e\ninnerStackTrace:$s');
  }
}

List<String> _parts(String value) => value.split(RegExp('[-_]'));

String _caseFirst(
  String value, {
  required bool upper,
  required bool lower,
}) {
  assert((upper && !lower) || (!upper && lower));
  final parts = value.split('');
  if (parts.isEmpty) {
    return value;
  }
  return [
    if (upper) parts.first.toUpperCase() else parts.first.toLowerCase(),
    ...parts.skip(1),
  ].join();
}

class TioUtils {
  const TioUtils._();

  static String lowerCamel(String value) => _parts(value)
      .indexed
      .map((e) => e.$1 == 0 ? lowerCaseFirst(e.$2) : upperCaseFirst(e.$2))
      .join();

  static String upperCamel(String value) =>
      _parts(value).map(upperCaseFirst).join();

  static String lowerCaseFirst(String value) =>
      _caseFirst(value, upper: false, lower: true);

  static String upperCaseFirst(String value) =>
      _caseFirst(value, upper: true, lower: false);
}
