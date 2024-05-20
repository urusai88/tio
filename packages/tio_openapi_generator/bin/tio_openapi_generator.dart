import 'dart:async';

import 'package:logging/logging.dart';
import 'package:tio_openapi_generator/src/runner.dart' as runner;

Future<void> main(List<String> args) async {
  Logger.root.onRecord.listen(
    (record) => Zone.current.print('[${record.level}] ${record.message}'),
  );

  await runner.run(args);
}
