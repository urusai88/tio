import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';

import '_internal.dart';

const accessTokenStale = 'stale';
const accessTokenFresh = 'fresh';
const badTokenMessage = 'please refresh access token';
const goodTokenMessage = 'access token is fine';

const errorCode = HttpStatus.notFound;
const errorEmpty = 'Unknown error';
const errorString = '404 Not Found';
const errorJson = {'message': errorString};

final _headersJson = <String, List<String>>{
  HttpHeaders.contentTypeHeader: ['${ContentType.json}'],
};

final _headersText = <String, List<String>>{
  HttpHeaders.contentTypeHeader: ['${ContentType.text}'],
};

T? _findEntity<T extends HasId>(Iterable<T> items, String id) =>
    items.firstWhereOrNull((e) => e.id == int.tryParse(id));

ResponseBody _responseJson(
  dynamic data, {
  int statusCode = 200,
  dynamic entityId,
}) {
  if (data != null) {
    return ResponseBody.fromString(
      jsonEncode(data),
      statusCode,
      headers: _headersJson,
    );
  } else {
    return ResponseBody.fromString(
      'Can not find an entity${entityId != null ? 'with id $entityId' : ""}',
      HttpStatus.notFound,
      headers: _headersText,
    );
  }
}

class TestHttpClientAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final segments =
        options.uri.pathSegments.map((e) => e.toLowerCase()).toList();

    switch (segments) {
      case ['method']:
        final method = switch (options.method.toUpperCase().trim()) {
          'GET' => 'GET',
          'POST' => 'POST',
          'PUT' => 'PUT',
          'HEAD' => 'HEAD',
          'PATCH' => 'PATCH',
          'DELETE' => 'DELETE',
          _ => 'UNKNOWN METHOD ${options.method}',
        };
        final headers = <String, List<String>>{};
        if (options.method.toUpperCase().trim() == 'GET') {
          headers['X-GET'] = ['TRUE'];
        }
        return ResponseBody.fromString(method, HttpStatus.ok, headers: headers);
      case ['long_job']:
        await Future<void>.delayed(const Duration(seconds: 10));
      case ['posts']:
        return _responseJson(posts);
      case ['posts', final id]:
        return _responseJson(_findEntity(posts, id));
      case ['todos']:
        return _responseJson(todos);
      case ['todos', final id]:
        return _responseJson(_findEntity(todos, id));
      case ['users', final id]:
        final accessToken =
            options.headers[HttpHeaders.authorizationHeader] as String?;
        if (accessToken == null) {
          return ResponseBody.fromString('', HttpStatus.unauthorized);
        } else {
          final user = users.firstWhereOrNull((e) => e.id == int.tryParse(id));
          if (user == null) {
            return ResponseBody.fromString('', HttpStatus.notFound);
          } else {
            if (user.accessToken == accessToken) {
              return _responseJson(user);
            } else {
              return ResponseBody.fromString('', HttpStatus.forbidden);
            }
          }
        }
      case ['check_access_token']:
        final accessToken =
            options.headers[HttpHeaders.authorizationHeader] as String?;
        if (accessToken != null) {
          if (accessToken == accessTokenStale) {
            return ResponseBody.fromString(
              badTokenMessage,
              HttpStatus.forbidden,
            );
          } else if (accessToken == accessTokenFresh) {
            return ResponseBody.fromString(goodTokenMessage, HttpStatus.ok);
          }
        }
      case ['refresh_access_token']:
        return _responseJson(
          const RefreshTokenResponse(a: accessTokenFresh, r: 'refresh_token'),
        );
      case ['404_empty']:
        return ResponseBody.fromString('', errorCode);
      case ['404_string']:
        return ResponseBody.fromString(errorString, errorCode);
      case ['404_json']:
        return _responseJson(errorJson, statusCode: errorCode);
      case _:
        return ResponseBody.fromString(
          'UNKNOWN SEGMENTS $segments',
          HttpStatus.badRequest,
        );
    }

    return ResponseBody.fromString('', 200);
  }
}

class TestAuthHttpClientAdapter implements HttpClientAdapter {
  TestAuthHttpClientAdapter() : _accessToken = _randomString();

  String _accessToken;

  var _count = 0;
  var _refreshCount = 0;

  String get accessToken => _accessToken;

  int get refreshCount => _refreshCount;

  static const max = 2;

  static final _random = Random();

  static String _randomString([int length = 16]) {
    const characters =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

    final result = StringBuffer();
    for (var i = 0; i < length; i++) {
      result.write(characters[_random.nextInt(characters.length)]);
    }
    return '$result';
  }

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final segments =
        options.uri.pathSegments.map((e) => e.toLowerCase()).toList();

    switch (segments) {
      case []:
        await Future<void>.delayed(const Duration(milliseconds: 100));
        final auth =
            options.headers[HttpHeaders.authorizationHeader] as String?;
        if (auth == null) {
          return ResponseBody.fromString('', HttpStatus.unauthorized);
        }
        if (auth != _accessToken || _count >= max) {
          return ResponseBody.fromString(badTokenMessage, HttpStatus.forbidden);
        }
        _count++;
        return ResponseBody.fromString('', HttpStatus.ok);
      case ['refresh']:
        await Future<void>.delayed(const Duration(milliseconds: 100));
        _accessToken = _randomString();
        _count = 0;
        _refreshCount++;
        return _responseJson(
          RefreshTokenResponse(a: _accessToken, r: 'refresh_token'),
        );
    }

    return ResponseBody.fromString('', HttpStatus.notFound);
  }
}
