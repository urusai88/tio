import 'package:test/test.dart';

import '_internal.dart';

void main() {
  test('auth interceptor refresh', () async {
    final tio = TioTest.auth(syncRefresh: false);
    final futures = <Future<dynamic>>[
      tio.service.index(),
      tio.service.index(),
      tio.service.index(),
      tio.service.index(),
    ];

    await Future.wait(futures);

    expect(tio.adapter.refreshCount, 2);
  });

  test('auth interceptor sync refresh', () async {
    final tio = TioTest.auth(syncRefresh: true);
    final futures = <Future<dynamic>>[
      tio.service.index(),
      tio.service.index(),
      tio.service.index(),
      tio.service.index(),
    ];

    await Future.wait(futures);

    expect(tio.adapter.refreshCount, 1);
  });
}
