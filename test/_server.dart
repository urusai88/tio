import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:test/test.dart';

import '_entities.dart';

const serverPort = 9000;

const accessTokenStale = 'stale';
const accessTokenFresh = 'fresh';
const badTokenMessage = 'please refresh token';
const goodTokenMessage = 'refresh token is fine';

T? _findEntity<T extends HasId>(Iterable<T> items, String id) =>
    items.firstWhereOrNull((e) => e.id == int.tryParse(id));

void _writeJson(HttpResponse response, dynamic data, [dynamic entityId]) {
  if (data != null) {
    response.headers.contentType = ContentType.json;
    response.statusCode = HttpStatus.ok;
    response.write(jsonEncode(data));
  } else {
    response.headers.contentType = ContentType.text;
    response.statusCode = HttpStatus.notFound;
    response.write(
      'Can not find an entity${entityId != null ? 'with id $entityId' : ""}',
    );
  }
}

Future<void> _serverListener(HttpRequest req) async {
  final resp = req.response;
  final segments = req.uri.pathSegments.map((e) => e.toLowerCase()).toList();

  switch (segments) {
    case ['long_job']:
      await Future<void>.delayed(const Duration(seconds: 10));
    case ['posts']:
      _writeJson(resp, posts);
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
