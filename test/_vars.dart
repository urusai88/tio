import 'package:tio/tio.dart';

import '_auth_interceptor.dart';
import '_entities.dart';
import '_server.dart';
import '_test_service.dart';
import '_typedefs.dart';

final factoryConfig = TioFactoryConfig<MyResponseError>(
  jsonFactoryList: const [
    TioJsonFactory(Todo.fromJson),
    TioJsonFactory(User.fromJson),
    TioJsonFactory(RefreshTokenResponse.fromJson),
  ],
  errorGroup: TioFactoryGroup(
    empty: (response) => const MyResponseError('Unknown error'),
    string: MyResponseError.new,
    json: const TioJsonFactory(MyResponseError.fromJson),
  ),
);

final dio = Dio(
  BaseOptions(baseUrl: 'http://127.0.0.1:$serverPort/'),
);

final client = Tio<MyResponseError>.withInterceptors(
  dio: dio,
  factoryConfig: factoryConfig,
  builders: [
    (client) => TestAuthInterceptor(client: client),
  ],
);

final testService = TestTioService(client: client);