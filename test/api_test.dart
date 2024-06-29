import 'package:test/test.dart';

import '_internal.dart';

void main() {
  final tio = TioTest.path();

  test(
    'todos with slash',
    () async =>
        expect(tio.service.todos(), completion(isA<MySuccess<List<Todo>>>())),
  );

  test(
    'todos without slash',
    () async =>
        expect(tio.service.todos2(), completion(isA<MySuccess<List<Todo>>>())),
  );

  test(
    'todo with slash',
    () async => expect(tio.service.todo(1), completion(isA<MySuccess<Todo>>())),
  );

  test(
    'todo without slash',
    () async =>
        expect(tio.service.todo2(1), completion(isA<MySuccess<Todo>>())),
  );
}
