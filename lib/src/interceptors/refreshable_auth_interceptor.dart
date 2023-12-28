import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../errors.dart';
import '../interceptor.dart';
import '../response.dart';

abstract interface class TioStorageKey<T> {
  Future<T?> get({T? defaultValue});

  Future<void> set(T value);

  Future<void> delete();
}

typedef TioTokenKey = TioStorageKey<String>;

class TioTokenRefreshResult {
  const TioTokenRefreshResult({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;
}

/// For personal use. Weak configurable and not fully tested
abstract base class TioRefreshableAuthInterceptor<R, ERR>
    extends TioInterceptor<ERR> {
  const TioRefreshableAuthInterceptor({required super.client});

  Logger get logger => Logger(loggerName);

  String get loggerName => 'RefreshableAuthInterceptor';

  TioTokenKey get accessTokenKey;

  TioTokenKey get refreshTokenKey;

  bool isTokenExpired(Response<dynamic> response, ERR error);

  Future<TioResponse<R, ERR>> refreshToken(String refreshToken);

  TioTokenRefreshResult getRefreshTokenResult(TioSuccess<R, ERR> success);

  RequestOptions setAccessToken(RequestOptions options, String accessToken) {
    final headers = {
      ...options.headers,
      HttpHeaders.authorizationHeader: accessToken,
    };

    // Because [RequestOptions] overloads [RequestOptions.headers] setter.
    return options.copyWith()..headers = headers;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await accessTokenKey.get();
    if (accessToken != null && accessToken.isNotEmpty) {
      if (options.enableAuth) {
        options = setAccessToken(options, accessToken);
      }
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    if (response == null) {
      return handler.next(err);
    }
    final error = client.transformError(response);
    if (!isTokenExpired(response, error)) {
      return handler.next(err);
    }
    logger.info(
      'refreshing token, data.runtimeType: ${_dataToString(response.data)}',
    );
    await _refreshToken();
    handler.resolve(await _restart(response));
  }

  Future<void> _refreshToken() async {
    final refreshToken = await refreshTokenKey.get();
    if (refreshToken == null) {
      logger.severe('refreshToken: $refreshToken');
      throw const TioException.middleware(
        message: 'refreshToken is null',
      );
    }

    switch (await this.refreshToken(refreshToken)) {
      case final TioSuccess<R, ERR> result:
        final data = getRefreshTokenResult(result);
        await accessTokenKey.set(data.accessToken);
        await refreshTokenKey.set(data.refreshToken);
      case final TioFailure<R, ERR> error:
        await accessTokenKey.delete();
        await refreshTokenKey.delete();
    }
  }

  static Options _optionsFromRequest(
    RequestOptions requestOptions,
  ) =>
      Options(
        method: requestOptions.method,
        sendTimeout: requestOptions.sendTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
        extra: requestOptions.extra,
        headers: requestOptions.headers,
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        validateStatus: requestOptions.validateStatus,
        receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
        followRedirects: requestOptions.followRedirects,
        maxRedirects: requestOptions.maxRedirects,
        persistentConnection: requestOptions.persistentConnection,
        requestEncoder: requestOptions.requestEncoder,
        responseDecoder: requestOptions.responseDecoder,
      );

  Future<Response<T>> _restart<T>(
    Response<T> originalResponse,
  ) {
    final originalOptions = originalResponse.requestOptions;
    return client.dio.request(
      originalOptions.path,
      options: _optionsFromRequest(originalOptions),
      data: originalOptions.data,
      queryParameters: originalOptions.queryParameters,
      onSendProgress: originalOptions.onSendProgress,
      onReceiveProgress: originalOptions.onReceiveProgress,
      cancelToken: originalOptions.cancelToken,
    );
  }

  static String _dataToString(dynamic data) =>
      data == null ? 'Null' : '${data.runtimeType}';
}

const _enableAuthKey = 'enableAuth';
const _enableAuthValue = true;

extension RefreshableAuthRequestOptionsX on RequestOptions {
  bool get enableAuth => (extra[_enableAuthKey] as bool?) ?? _enableAuthValue;

  set enableAuth(bool value) => extra[_enableAuthKey] = value;
}

extension RefreshableAuthOptionsX on Options {
  bool get enableAuth => (extra?[_enableAuthKey] as bool?) ?? _enableAuthValue;

  set enableAuth(bool value) {
    extra ??= <String, dynamic>{};
    extra![_enableAuthKey] = value;
  }
}
