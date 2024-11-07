import 'package:dio/dio.dart';
import 'package:tio/tio.dart';

import '_internal.dart';

class TioTest<T, A extends HttpClientAdapter> {
  const TioTest({
    required this.dio,
    required this.tio,
    required this.service,
    required this.adapter,
  });

  final Dio dio;
  final Tio<MyResponseError> tio;
  final T service;
  final A adapter;

  static TioTest<TestTioService, TestHttpClientAdapter> main() {
    final dio = Dio()..httpClientAdapter = TestHttpClientAdapter();
    final tio = Tio<MyResponseError>.withInterceptors(
      dio: dio,
      factoryConfig: factoryConfig,
    );
    final service = TestTioService(tio: tio);
    return TioTest(
      dio: dio,
      tio: tio,
      service: service,
      adapter: dio.httpClientAdapter as TestHttpClientAdapter,
    );
  }

  static TioTest<TestTioApiWithPath, TestHttpClientAdapter> path() {
    final dio = Dio()..httpClientAdapter = TestHttpClientAdapter();
    final tio = Tio<MyResponseError>.withInterceptors(
      dio: dio,
      factoryConfig: factoryConfig,
    );
    final service = TestTioApiWithPath(tio: tio);
    return TioTest(
      dio: dio,
      tio: tio,
      service: service,
      adapter: dio.httpClientAdapter as TestHttpClientAdapter,
    );
  }

  static TioTest<TestAuthTioService, TestAuthHttpClientAdapter> auth({
    required bool syncRefresh,
  }) {
    final adapter = TestAuthHttpClientAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    final tio = Tio<MyResponseError>.withInterceptors(
      dio: dio,
      factoryConfig: factoryConfig,
    );
    final service = TestAuthTioService(tio: tio);
    dio.interceptors.add(
      TestAuthInterceptor(
        tio: tio,
        service: service,
        accessTokenKey: TestTioStorageKey(adapter.accessToken),
        syncRefresh: syncRefresh,
      ),
    );
    return TioTest(dio: dio, tio: tio, service: service, adapter: adapter);
  }
}

final emptyResponse = Response<dynamic>(requestOptions: RequestOptions());

const factoryConfig = TioFactoryConfig<MyResponseError>(
  list: {
    Todo.fromJson,
    User.fromJson,
    RefreshTokenResponse.fromJson,
  },
  errorJsonFactory: MyResponseError.fromJson,
  errorStringFactory: MyResponseError.fromString,
);
