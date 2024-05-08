import 'package:test/test.dart';

import '_internal.dart';

void main() {
  upAndDownTest();

  group(
    'api tests',
    () {
      test(
        'todos with slash',
        () async => expect(
          testService2.todos(),
          completion(isA<MySuccess<List<Todo>>>()),
        ),
      );

      test(
        'todos without slash',
        () async => expect(
          testService2.todos2(),
          completion(isA<MySuccess<List<Todo>>>()),
        ),
      );

      test(
        'todo with slash',
        () async => expect(
          testService2.todo(1),
          completion(isA<MySuccess<Todo>>()),
        ),
      );

      test(
        'todo without slash',
        () async => expect(
          testService2.todo2(1),
          completion(isA<MySuccess<Todo>>()),
        ),
      );
    },
  );
}
