import 'package:test/test.dart';
import 'package:tio/tio.dart';

import '_internal.dart';

void main() {
  test('tio factory config', () {
    final factoryConfig = TioFactoryConfig<int>(
      const [
        TioJsonFactory<User>(User.fromJson),
      ],
      errorGroup: TioFactoryGroup(
        empty: TioEmptyFactory(() => 0),
        string: TioStringFactory((string) => int.tryParse(string) ?? 0),
        json: TioJsonFactory((json) => json['code'] as int),
      ),
    );

    expect(factoryConfig.contains<User>(), isTrue);
    expect(factoryConfig.contains<Todo>(), isFalse);
    expect(factoryConfig.get<User>(), isNotNull);
    expect(factoryConfig.get<Todo>(), isNull);
    expect(factoryConfig.errorGroup.empty(), 0);
    expect(factoryConfig.errorGroup.string('123'), 123);
    expect(factoryConfig.errorGroup.json(const {'code': 312}), 312);
  });

  test('tio response', () {
    // ignore: prefer_const_declarations
    final success = const TioResponse<String, int>.success(
      response: null,
      result: 'result',
    );

    // ignore: prefer_const_declarations
    final failure = const TioResponse<String, int>.failure(
      response: null,
      error: 1,
    );

    expect(
      success.withSuccess<bool>((current) => true),
      isA<TioSuccess<bool, int>>()
          .having((success) => success.result, 'result', isTrue),
    );

    expect(
      failure.withSuccess<bool>((current) => true),
      isA<TioFailure<bool, int>>(),
    );
  });
}
