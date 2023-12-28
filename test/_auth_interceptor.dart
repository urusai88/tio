import 'dart:io';

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

final class TestAuthInterceptor extends TioRefreshableAuthInterceptor<
    RefreshTokenResponse, MyResponseError> {
  TestAuthInterceptor({required super.client});

  @override
  final accessTokenKey = TestTioStorageKey(users.first.accessToken);

  @override
  final refreshTokenKey = TestTioStorageKey('refresh_token');

  @override
  bool isTokenExpired(Response<dynamic> response, MyResponseError error) =>
      response.statusCode == HttpStatus.forbidden &&
      error.message == badTokenMessage;

  @override
  Future<TioResponse<RefreshTokenResponse, MyResponseError>> refreshToken(
    String refreshToken,
  ) =>
      testService.refreshAccessToken();

  @override
  TioTokenRefreshResult getRefreshTokenResult(
    TioSuccess<RefreshTokenResponse, MyResponseError> success,
  ) =>
      TioTokenRefreshResult(
        accessToken: success.result.a,
        refreshToken: success.result.r,
      );
}
