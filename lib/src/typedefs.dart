import 'package:dio/dio.dart';

import 'interceptor.dart';
import 'responses/response.dart';
import 'tio.dart';

typedef JsonMap = Map<String, dynamic>;

// class TioFactory<R, V> {
//   const TioFactory._(this.factory);
//
//   factory TioFactory.string(
//     R Function(String value) factory,
//   ) =>
//       TioStringFactory<R, String>._(factory);
//
//   static TioJsonFactory<T> json<T>(T Function(JsonMap value) factory) =>
//       TioJsonFactory<T>._(factory);
//
//   static TioFactoryGroup<E> group<E>({
//     // required TioEmptyFactory<E> empty,
//     required TioStringFactory<E> string,
//     required TioJsonFactory<E> json,
//   }) =>
//       TioFactoryGroup(
//         // empty: empty,
//         string: string,
//         json: json,
//       );
//
//   static TioFactoryConfig<E> config<E>({
//     required TioFactoryGroup<E> errorGroup,
//   }) =>
//       TioFactoryConfig(errorGroup: errorGroup);
//
//   final R Function(V value) factory;
//
//   R call(V value);
// }

typedef TioJsonFactory<T> = T Function(JsonMap value);
typedef TioStringFactory<T> = T Function(String value);

typedef TioResponseTransformer<T, E, D> = TioResponse<T, E> Function(
  Response<D> resp,
);

typedef TioResultTransformer<R, E, T> = T Function(TioSuccess<R, E> current);

typedef TioInterceptorBuilder<E> = TioInterceptor<E> Function(Tio<E> tio);
