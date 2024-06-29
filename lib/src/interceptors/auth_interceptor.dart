import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../errors.dart';
import '../interceptor.dart';
import '../response.dart';
import '../x.dart';

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
abstract base class TioAuthInterceptor<T, E> extends TioInterceptor<E> {
  TioAuthInterceptor({
    required super.tio,
    this.syncRefresh = false,
  });

  final bool syncRefresh;

  Completer<dynamic>? _syncCompleter;

  Logger get logger => Logger(loggerName);

  String get loggerName => 'RefreshableAuthInterceptor';

  TioTokenKey get accessTokenKey;

  TioTokenKey get refreshTokenKey;

  bool isTokenExpired(Response<dynamic> response, E error);

  Future<TioResponse<T, E>> refreshToken(String refreshToken);

  TioTokenRefreshResult getRefreshTokenResult(
    TioSuccess<T, E> success,
  );

  Future<void> onFailureRefresh(TioFailure<T, E> failure);

  RequestOptions setAccessToken(RequestOptions options, String accessToken) {
    final headers = {
      ...options.headers,
      'authorization': accessToken,
    };

    // Because [RequestOptions] overloads [RequestOptions.headers] setter.
    return options.copyWith()..headers = headers;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.enableAuth) {
      final accessToken = await accessTokenKey.get();
      if (accessToken != null && accessToken.isNotEmpty) {
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
    final error = tio.transformError(response);
    if (!isTokenExpired(response, error)) {
      return handler.next(err);
    }
    logger.info(
      'refreshing token, data.runtimeType: ${_dataToString(response.data)}',
    );

    if (_syncCompleter != null) {
      await _syncCompleter!.future;
    } else {
      if (syncRefresh) {
        _syncCompleter = Completer();
      }
      await _refreshToken(err, handler).then((_) {
        _syncCompleter?.complete();
        _syncCompleter = null;
      });
    }
    if (!handler.isCompleted) {
      handler.resolve(await tio.dio.restart(response));
    }
  }

  Future<void> _refreshToken(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final refreshToken = await refreshTokenKey.get();
    if (refreshToken == null) {
      logger.severe('refreshToken: $refreshToken');
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: const TioError.transform(),
          stackTrace: StackTrace.current,
          message: 'refreshToken is null',
        ),
      );
    }

    /// @TODO(urusai88): make this actions more configurable
    switch (await this.refreshToken(refreshToken)) {
      case final TioSuccess<T, E> result:
        final data = getRefreshTokenResult(result);
        await accessTokenKey.set(data.accessToken);
        await refreshTokenKey.set(data.refreshToken);
      case final TioFailure<T, E> failure:
        await onFailureRefresh(failure);
    }
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
