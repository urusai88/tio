import 'dart:io';

import 'package:test/test.dart';

import '_internal.dart';

void main() {
  final tio = TioTest.main();

  test(
    'get todos, success',
    () async => expect(
      tio.service.todos(),
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
            )
            .having(
              (success) =>
                  success.map(success: (_) => true, failure: (_) => false),
              'map',
              isTrue,
            ),
      ),
    ),
  );

  test(
    'get first todo, success',
    () async => expect(
      tio.service.todo(todos.first.id),
      completion(
        isA<MySuccess<Todo>>()
            .having((success) => success.result, 'result', todos.first),
      ),
    ),
  );

  test(
    'get wrong todo, failure with 404',
    () async => expect(
      tio.service.todo(0),
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
            )
            .having(
              (success) =>
                  success.map(success: (_) => true, failure: (_) => false),
              'map',
              isFalse,
            ),
      ),
    ),
  );
}
