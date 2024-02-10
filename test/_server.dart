import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:test/test.dart';

import '_entities.dart';

const serverPort = 9000;

const accessTokenStale = 'stale';
const accessTokenFresh = 'fresh';
const badTokenMessage = 'please refresh access token';
const goodTokenMessage = 'access token is fine';

const errorCode = HttpStatus.notFound;
const errorEmpty = 'Unknown error';
const errorString = '404 Not Found';
const errorJson = {'message': errorString};

T? _findEntity<T extends HasId>(Iterable<T> items, String id) =>
    items.firstWhereOrNull((e) => e.id == int.tryParse(id));

void _writeJson(
  HttpResponse response,
  dynamic data, {
  bool sendStatusCode = true,
  dynamic entityId,
}) {
  if (data != null) {
    response.headers.contentType = ContentType.json;
    if (sendStatusCode) {
      response.statusCode = HttpStatus.ok;
    }
    response.write(jsonEncode(data));
  } else {
    response.headers.contentType = ContentType.text;
    if (sendStatusCode) {
      response.statusCode = HttpStatus.notFound;
    }
    response.write(
      'Can not find an entity${entityId != null ? 'with id $entityId' : ""}',
    );
  }
}

Future<void> _serverListener(HttpRequest req) async {
  final resp = req.response;
  final segments = req.uri.pathSegments.map((e) => e.toLowerCase()).toList();

  switch (segments) {
    case ['method']:
      final method = switch (req.method.toUpperCase().trim()) {
        'GET' => 'GET',
        'POST' => 'POST',
        'PUT' => 'PUT',
        'HEAD' => 'HEAD',
        'PATCH' => 'PATCH',
        'DELETE' => 'DELETE',
        _ => 'UNKNOWN METHOD ${req.method}',
      };
      if (req.method.toUpperCase().trim() == 'GET') {
        resp.headers.set('X-GET', 'TRUE');
      }
      resp.write(method);
    case ['long_job']:
      await Future<void>.delayed(const Duration(seconds: 10));
    case ['posts']:
      _writeJson(resp, posts);
    case ['posts', final id]:
      _writeJson(resp, _findEntity(posts, id));
    case ['todos']:
      _writeJson(resp, todos);
    case ['todos', final id]:
      _writeJson(resp, _findEntity(todos, id));
    case ['users', final id]:
      final accessToken = req.headers[HttpHeaders.authorizationHeader]?.first;
      if (accessToken == null) {
        resp.statusCode = HttpStatus.unauthorized;
      } else {
        final user = users.firstWhereOrNull((e) => e.id == int.tryParse(id));
        if (user == null) {
          resp.statusCode = HttpStatus.notFound;
        } else {
          if (user.accessToken == accessToken) {
            _writeJson(resp, user);
          } else {
            resp.statusCode = HttpStatus.forbidden;
          }
        }
      }
    case ['check_access_token']:
      final accessToken = req.headers[HttpHeaders.authorizationHeader]?.first;
      if (accessToken != null) {
        if (accessToken == accessTokenStale) {
          resp.statusCode = HttpStatus.forbidden;
          resp.write(badTokenMessage);
        } else if (accessToken == accessTokenFresh) {
          resp.write(goodTokenMessage);
        }
      }
    case ['refresh_access_token']:
      _writeJson(
        resp,
        const RefreshTokenResponse(a: accessTokenFresh, r: 'refresh_token'),
      );
    case ['404_empty']:
      resp.statusCode = errorCode;
    case ['404_string']:
      resp.statusCode = errorCode;
      resp.write(errorString);
    case ['404_json']:
      resp.statusCode = errorCode;
      _writeJson(resp, errorJson, sendStatusCode: false);
    case _:
      resp.statusCode = HttpStatus.badRequest;
      resp.write('UNKNOWN SEGMENTS $segments');
  }

  await resp.close();
}

Future<HttpServer> startHttpServer() {
  return HttpServer.bind(InternetAddress.loopbackIPv4, serverPort).then(
    (server) => server..listen(_serverListener),
  );
}

Future<HttpServer?> stopHttpServer(HttpServer? server) async {
  await server?.close(force: true);
  return null;
}

void upAndDownTest() {
  HttpServer? server;

  setUpAll(() async => server = await startHttpServer());
  tearDownAll(() async => server = await stopHttpServer(server));
}
