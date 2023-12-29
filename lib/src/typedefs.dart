import 'package:dio/dio.dart';

import 'client.dart';
import 'interceptor.dart';
import 'response.dart';

typedef JSON = Map<String, dynamic>;

typedef TioEmptyFactory<T> = T Function(Response<dynamic>? response);
typedef TioStringFactory<T> = T Function(String body);

class TioJsonFactory<T> {
  const TioJsonFactory(this.factory);

  final T Function(JSON json) factory;

  T call(JSON json) => factory(json);
}

typedef TioResponseTransformer<T, E, D> = TioResponse<T, E> Function(
  Response<D> resp,
);

typedef TioResultTransformer<T, E, R> = R Function(
  TioSuccess<T, E> current,
);

typedef TioInterceptorBuilder<E> = TioInterceptor<E> Function(
  Tio<E> client,
);
