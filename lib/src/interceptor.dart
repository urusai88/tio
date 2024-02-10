import 'package:dio/dio.dart';

import 'tio.dart';

export 'interceptors/auth_interceptor.dart';

class TioInterceptor<E> extends Interceptor {
  const TioInterceptor({required this.tio});

  final Tio<E> tio;
}
