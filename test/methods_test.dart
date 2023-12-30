import 'package:test/test.dart';

import '_internal.dart';

void main() {
  upAndDownTest();

  void testMethod(String method, Future<MyResponse<String>> Function() fn) {
    test(
      'method $method',
      () async => expect(
        fn(),
        completion(
          isA<MySuccess<String>>()
              .having(
                (s) => s.result,
                'result',
                predicate(
                  (result) =>
                      method == 'HEAD' ? result == '' : result == method,
                ),
              )
              .having(
                (s) => s.response?.requestOptions.method,
                'response.requestOptions.method',
                method,
              ),
        ),
      ),
    );
  }

  testMethod('GET', testService.methodGet);
  testMethod('POST', testService.methodPost);
  testMethod('PUT', testService.methodPut);
  testMethod('HEAD', testService.methodHead);
  testMethod('PATCH', testService.methodPatch);
  testMethod('DELETE', testService.methodDelete);
}
