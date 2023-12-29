import 'package:test/test.dart';
import 'package:tio/tio.dart';

import '_internal.dart';

void main() {
  upAndDownTest();

  group('error', () {
    test(
      'no factory',
      () async => expect(
        testService.posts(),
        throwsA(
          isA<TioError>().having(
            (error) => error.type,
            'type',
            equals(TioErrorType.config),
          ),
        ),
      ),
    );

    test(
      'transformation error many',
      () async => expect(
        testService.postsAsUsers(),
        throwsA(
          isA<TioException>().having(
            (error) => error.type,
            'type',
            equals(TioExceptionType.middleware),
          ),
        ),
      ),
    );

    test(
      'transformation error one',
      () async => expect(
        testService.postAsUser(1),
        throwsA(
          isA<TioException>().having(
            (error) => error.type,
            'type',
            equals(TioExceptionType.middleware),
          ),
        ),
      ),
    );

    test(
      'error empty',
      () async => expect(
        testService.error404empty(),
        completion(
          isA<MyFailure<User>>().having(
            (error) => error.error,
            'error',
            const MyResponseError(errorEmpty),
          ),
        ),
      ),
    );

    test(
      'error string',
      () async => expect(
        testService.error404string(),
        completion(
          isA<MyFailure<User>>().having(
            (error) => error.error,
            'error',
            const MyResponseError(errorString),
          ),
        ),
      ),
    );

    test(
      'error json',
      () async => expect(
        testService.error404json(),
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
          final future = testService.long(cancelToken);
          Future<void>.delayed(const Duration(seconds: 1), cancelToken.cancel);
          return future;
        }),
        throwsA(
          isA<TioException>()
              .having(
                (error) => error.type,
                'type',
                equals(TioExceptionType.dio),
              )
              .having(
                (error) => error.dioException,
                'dioException',
                isNotNull,
              )
              .having(
                (error) => error.dioException?.type,
                'dioException.type',
                DioExceptionType.cancel,
              ),
        ),
      ),
    );
  });
}
