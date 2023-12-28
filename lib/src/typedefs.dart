import '../tio.dart';

typedef JSON = Map<String, dynamic>;

typedef TioEmptyFactory<T> = T Function(Response<dynamic>? response);
typedef TioStringFactory<T> = T Function(String body);

class TioJsonFactory<T> {
  const TioJsonFactory(this.factory);

  final T Function(JSON json) factory;

  T call(JSON json) => factory(json);
}

typedef TioResponseTransformer<R, ERR, D> = TioResponse<R, ERR> Function(
  Response<D> resp,
);

typedef TioResultTransformer<R, ERR, R1> = R1 Function(
  TioSuccess<R, ERR> current,
);

typedef TioInterceptorBuilder<ERR> = TioInterceptor<ERR> Function(
  Tio<ERR> client,
);

class TioRequestExtra {
  const TioRequestExtra({this.ignoreAuth = false});

  final bool ignoreAuth;
}

class TioResponseExtra {
  const TioResponseExtra(this.response);

  final Response<dynamic>? response;
}
