import 'package:dio/dio.dart';
import 'package:tio/tio.dart';

import '_internal.dart';

class TestTioStorageKey<T> implements TioStorageKey<T> {
  TestTioStorageKey([this.value]);

  T? value;

  @override
  Future<void> delete() async => value = null;

  @override
  Future<T?> get({T? defaultValue}) async => value;

  @override
  Future<void> set(T value) async => this.value = value;
}

abstract interface class TestAuthService {
  Future<MyResponse<RefreshTokenResponse>> refresh();
}

final class TestAuthInterceptor
    extends TioAuthInterceptor<RefreshTokenResponse, MyResponseError> {
  TestAuthInterceptor({
    required super.tio,
    required this.service,
    required this.accessTokenKey,
    super.syncRefresh,
  });

  final TestAuthService service;

  @override
  final TestTioStorageKey<String> accessTokenKey;

  @override
  final refreshTokenKey = TestTioStorageKey('refresh_token');

  @override
  bool isTokenExpired(Response<dynamic> response, MyResponseError error) =>
      error.message == badTokenMessage;

  @override
  Future<TioResponse<RefreshTokenResponse, MyResponseError>> refreshToken(
    String refreshToken,
  ) =>
      service.refresh();

  @override
  TioTokenRefreshResult getRefreshTokenResult(
    TioSuccess<RefreshTokenResponse, MyResponseError> success,
  ) =>
      TioTokenRefreshResult(
        accessToken: success.result.a,
        refreshToken: success.result.r,
      );

  @override
  Future<void> onFailureRefresh(
    TioFailure<RefreshTokenResponse, MyResponseError> failure,
  ) async {
    await accessTokenKey.delete();
    await refreshTokenKey.delete();
  }
}
