import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:tio/tio.dart';

import '_internal.dart';

void main() {
  final tio = TioTest.main();
  test(
    'no factory',
    () async => expect(
      tio.service.posts(),
      throwsA(
        isA<DioException>()
            .having((error) => error.error, 'error', isA<TioConfigError>()),
      ),
    ),
  );

  test(
    'transformation error many',
    () async => expect(
      tio.service.postsAsUsers(),
      throwsA(
        isA<DioException>()
            .having((error) => error.error, 'error', isA<TioTransformError>()),
      ),
    ),
  );

  test(
    'transformation error one',
    () async => expect(
      tio.service.postAsUser(1),
      throwsA(
        isA<DioException>()
            .having((error) => error.error, 'error', isA<TioTransformError>()),
      ),
    ),
  );

  test(
    'error empty',
    () async => expect(
      tio.service.error404empty(),
      completion(
        isA<MyFailure<User>>().having(
          (error) => error.error,
          'error',
          const MyResponseError.fromString(errorEmpty),
        ),
      ),
    ),
  );

  test(
    'error string',
    () async => expect(
      tio.service.error404string(),
      completion(
        isA<MyFailure<User>>().having(
          (error) => error.error,
          'error',
          const MyResponseError.fromString(errorString),
        ),
      ),
    ),
  );

  test(
    'error json',
    () async => expect(
      tio.service.error404json(),
      completion(
        isA<MyFailure<User>>().having(
          (error) => error.error,
          'error',
          MyResponseError.fromJson(errorJson),
        ),
      ),
    ),
  );

  test(
    'cancel',
    () async => expect(
      Future(() {
        final cancelToken = CancelToken();
        final future = tio.service.long(cancelToken);
        Future<void>.delayed(const Duration(seconds: 1), cancelToken.cancel);
        return future;
      }),
      throwsA(
        isA<DioException>()
            .having((error) => error.type, 'type', DioExceptionType.cancel),
      ),
    ),
  );
}
