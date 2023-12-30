import 'dart:io';

import 'package:test/test.dart';
import 'package:tio/tio.dart';

import '_internal.dart';

void main() {
  upAndDownTest();

  final interceptor = testService.client.dio.interceptors
      .whereType<TestAuthInterceptor>()
      .first;

  group('auth', () {
    test(
      'trying to get self user',
      () async => expect(
        testService.user(users.first.id),
        completion(
          isA<MySuccess<User>>()
              .having((success) => success.result, 'result', users.first),
        ),
      ),
    );

    test(
      'trying to get not self user',
      () async => expect(
        testService.user(users.last.id),
        completion(
          isA<MyFailure<User>>().having(
            (failure) => failure.response?.statusCode,
            'statusCode',
            HttpStatus.forbidden,
          ),
        ),
      ),
    );

    test(
      'ignore auth',
      () async => expect(
        testService.user(users.last.id, enableAuth: false),
        completion(
          isA<MyFailure<User>>().having(
            (failure) => failure.response?.statusCode,
            'statusCode',
            HttpStatus.unauthorized,
          ),
        ),
      ),
    );

    test('refresh token', () async {
      await interceptor.accessTokenKey.set(accessTokenStale);

      await expectLater(
        testService.checkAccessToken(),
        completion(
          isA<MySuccess<String>>()
              .having((success) => success.result, 'result', goodTokenMessage),
        ),
      );

      expect(await interceptor.accessTokenKey.get(), accessTokenFresh);
    });

    test('refresh token failure', () async {
      await interceptor.accessTokenKey.set(accessTokenStale);
      final refreshToken = (await interceptor.refreshTokenKey.get())!;
      await interceptor.refreshTokenKey.delete();
      await expectLater(
        testService.checkAccessToken(),
        throwsA(
          isA<TioException>()
              .having((e) => e.type, 'type', TioExceptionType.middleware),
        ),
      );
      expect(await interceptor.accessTokenKey.get(), accessTokenStale);
      await interceptor.accessTokenKey.set(accessTokenFresh);
      await interceptor.refreshTokenKey.set(refreshToken);
    });
  });
}
