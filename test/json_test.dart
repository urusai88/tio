import 'dart:io';

import 'package:test/test.dart';

import '_internal.dart';

void main() {
  upAndDownTest();

  group(
    'json',
    () {
      test(
        'get todos, success',
        () async => expect(
          testService.todos(),
          completion(
            isA<MySuccess<List<Todo>>>()
                .having(
                  (success) => success.result,
                  'result',
                  unorderedEquals(todos),
                )
                .having(
                  (success) => success,
                  'toString',
                  predicate<MySuccess<List<Todo>>>(
                    (success) =>
                        '$success' ==
                        'TioSuccess(result: ${success.result}, statusCode: ${success.response?.statusCode})',
                  ),
                ),
          ),
        ),
      );

      test(
        'get first todo, success',
        () async => expect(
          testService.todo(todos.first.id),
          completion(
            isA<MySuccess<Todo>>()
                .having((success) => success.result, 'result', todos.first),
          ),
        ),
      );

      test(
        'get wrong todo, failure with 404',
        () async => expect(
          testService.todo(0),
          completion(
            isA<MyFailure<Todo>>()
                .having(
                  (failure) => failure.response?.statusCode,
                  'error',
                  HttpStatus.notFound,
                )
                .having(
                  (failure) => failure,
                  'toString',
                  predicate<MyFailure<Todo>>(
                    (failure) =>
                        '$failure' ==
                        'TioFailure(error: ${failure.error}, statusCode: ${failure.response?.statusCode})',
                  ),
                ),
          ),
        ),
      );
    },
  );
}
