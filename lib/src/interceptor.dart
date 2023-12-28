import 'package:dio/dio.dart';

import 'client.dart';

export 'interceptors/refreshable_auth_interceptor.dart';

class TioInterceptor<ERR> extends Interceptor {
  const TioInterceptor({required this.client});

  final Tio<ERR> client;
}
