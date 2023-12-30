import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'errors.dart';
import 'factory_config.dart';
import 'response.dart';
import 'typedefs.dart';
import 'x.dart';

class Tio<E> {
  const Tio({required this.dio, required this.factoryConfig});

  factory Tio.withInterceptors({
    required Dio dio,
    required TioFactoryConfig<E> factoryConfig,
    List<TioInterceptorBuilder<E>> builders = const [],
  }) {
    final tio = Tio(dio: dio, factoryConfig: factoryConfig);
    for (final builder in builders) {
      dio.interceptors.add(builder(tio));
    }
    return tio;
  }

  final Dio dio;
  final TioFactoryConfig<E> factoryConfig;

  // bool _needsCheckFactory<T>() {
  //   return T != String && T != int && T != Uint8List && T != List<dynamic>;
  // }

  TioJsonFactory<T> _checkFactory<T>() {
    final factory = factoryConfig.get<T>();
    if (factory == null) {
      final containsFactories =
          factoryConfig.containsFactories.map((e) => '[$e]').join(', ');
      throw TioError.config(
        message:
            'Can not find factory for [$T] type. Found factories for $containsFactories.',
      );
    }
    return factory;
  }

  TioResponse<String, E> transformString(Response<String> resp) =>
      TioResponse.success(
        response: resp,
        result: resp.data!,
      );

  TioResponse<Uint8List, E> transformBytes(Response<Uint8List> resp) =>
      TioResponse.success(
        response: resp,
        result: resp.data!,
      );

  TioResponse<ResponseBody, E> transformStream(Response<ResponseBody> resp) =>
      TioResponse.success(
        response: resp,
        result: resp.data!,
      );

  TioResponse<T, E> transformOne<T>(Response<JSON> resp) {
    final factory = _checkFactory<T>();
    final data = resp.data;
    if (data is! JSON) {
      throw const TioException.middleware();
    }
    final json = JSON.from(data);
    try {
      return TioResponse.success(
        response: resp,
        result: factory(json),
      );
    } catch (e, s) {
      throw TioException.middleware(message: '$e', stackTrace: s);
    }
  }

  TioResponse<List<T>, E> transformMany<T>(Response<List<dynamic>> resp) {
    final factory = _checkFactory<T>();
    final json = resp.data?.castChecked<JSON>();
    if (json == null) {
      throw const TioException.middleware();
    }

    try {
      final result = json.map(factory.call).toList();
      return TioResponse.success(
        response: resp,
        result: result,
      );
    } catch (e, s) {
      throw TioException.middleware(message: '$e', stackTrace: s);
    }
  }

  TioResponse<void, E> transformEmpty(Response<dynamic> resp) =>
      TioResponse.success(response: resp, result: null);

  E transformError(Response<dynamic> resp) {
    final group = factoryConfig.errorGroup;

    try {
      return switch (resp.data) {
        final String string when string.isEmpty => group.empty(),
        final String string => group.string(string),
        final JSON json => group.json(json),
        _ => group.empty(),
      };
    } catch (e, s) {
      throw TioException.middleware(message: '$e', stackTrace: s);
    }
  }

  Future<TioResponse<T, E>> request<T, D>(
    String path,
    TioResponseTransformer<T, E, D> transformer, {
    Object? data,
    JSON? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await dio
          .request<D>(
            path,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: checkOptions(options: options),
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          )
          .then(transformer);
    } on DioException catch (e, s) {
      if (e.type == DioExceptionType.badResponse) {
        return TioResponse.failure(
          response: e.response,
          error: transformError(e.response!),
        );
      }
      throw TioException.dio(dioException: e, stackTrace: s);
    }
  }

  /// Adds a method and responseType to the [Options] if they are absent.
  Options? checkOptions({
    Options? options,
    String? method,
    ResponseType? responseType,
  }) =>
      (options ?? Options())
          .copyWith(method: method, responseType: responseType);
}
