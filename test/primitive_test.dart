import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:test/test.dart';

import '_internal.dart';

void main() {
  upAndDownTest();

  group('primitive', () {
    test(
      'todos as string',
      () async => expect(
        testService.todosAsString(),
        completion(
          isA<MySuccess<String>>().having(
            (success) => success.result,
            'result',
            jsonEncode(todos),
          ),
        ),
      ),
    );

    test(
      'encoded todos as bytes',
      () async => expect(
        testService.todosAsBytes(),
        completion(
          isA<MySuccess<Uint8List>>().having(
            (success) => success.result,
            'result',
            utf8.encode(jsonEncode(todos)),
          ),
        ),
      ),
    );

    test(
      'stream response',
      () async => expect(
        testService.todosAsStream(),
        completion(
          isA<MySuccess<ResponseBody>>().having(
            (success) =>
                success.result.stream.expand((e) => e.toList()).toList(),
            'result',
            completion(utf8.encode(jsonEncode(todos))),
          ),
        ),
      ),
    );

    test(
      'empty response',
      () async => expect(
        testService.todosAsEmpty(),
        completion(
          isA<MySuccess<void>>()
              .having((success) => success.result, 'result', isNull),
        ),
      ),
    );
  });
}
