import 'dart:convert';
import 'dart:io';

import 'package:tio/tio.dart';
import 'package:yaml/yaml.dart';

import 'entities.dart';

const _yamlExtension = '.yaml';
const _jsonExtension = '.json';
const _supportVersion = '3.1.0';

const _invalidMessage = 'openapi file contents is not JSON or YAML object';

dynamic convertYaml(dynamic value) {
  return switch (value) {
    final YamlMap node => JSON.fromEntries(
        node.entries
            .map((e) => MapEntry(e.key as String, convertYaml(e.value))),
      ),
    final YamlList node => node.map(convertYaml).toList(),
    _ => value,
  };
}

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
      tmp = convertYaml(tmp);
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
