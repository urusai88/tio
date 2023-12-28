import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'errors.dart';
import 'factory_config.dart';
import 'response.dart';
import 'typedefs.dart';
import 'x.dart';

class TioService<ERR> {
  const TioService({required this.client, this.path = '/'});

  final Tio<ERR> client;

  final String path;
}

class Tio<ERR> {
  const Tio({required this.dio, required this.factoryConfig});

  Tio.withInterceptors({
    required this.dio,
    required this.factoryConfig,
    List<TioInterceptorBuilder<ERR>> builders = const [],
  }) {
    for (final builder in builders) {
      dio.interceptors.add(builder(this));
    }
  }

  final Dio dio;
  final TioFactoryConfig<ERR> factoryConfig;

  // bool _needsCheckFactory<T>() {
  //   return T != String && T != int && T != Uint8List && T != List<dynamic>;
  // }

  TioJsonFactory<T> _checkFactory<T>() {
    final factory = factoryConfig.get<T>();
    if (factory == null) {
      throw TioError.config(
        message: 'Can not find factory for [$T] type',
      );
    }
    return factory;
  }

  TioResponse<String, ERR> transformString(Response<String> resp) =>
      TioResponse.success(
        response: resp,
        result: resp.data!,
      );

  TioResponse<Uint8List, ERR> transformBytes(Response<Uint8List> resp) =>
      TioResponse.success(
        response: resp,
        result: resp.data!,
      );

  TioResponse<ResponseBody, ERR> transformStream(Response<ResponseBody> resp) =>
      TioResponse.success(
        response: resp,
        result: resp.data!,
      );

  TioResponse<R, ERR> transformOne<R>(Response<JSON> resp) {
    final factory = _checkFactory<R>();
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

  TioResponse<List<R>, ERR> transformMany<R>(Response<List<dynamic>> resp) {
    final factory = _checkFactory<R>();
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

  TioResponse<void, ERR> transformEmpty(Response<dynamic> resp) =>
      TioResponse.success(response: resp, result: null);

  ERR transformError(Response<dynamic> resp) {
    final group = factoryConfig.errorGroup;
    final data = resp.data;
    if (data == null || ((data is String) && data.isEmpty)) {
      return group.empty(resp);
    }

    try {
      return switch (data) {
        final String string when string.isEmpty => group.empty(resp),
        final String string => group.string(string),
        final JSON json => group.json(json),
        _ => group.empty(resp),
      };
    } catch (e, s) {
      throw TioException.middleware(message: '$e', stackTrace: s);
    }
  }

  Future<TioResponse<R, ERR>> request<R, D>(
    String path,
    TioResponseTransformer<R, ERR, D> transformer, {
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

  // static Response<T> castResponse<T>(Response<dynamic> response) {
  //   return Response<T>(
  //     data: response.data != null ? response.data as T : null,
  //     requestOptions: response.requestOptions,
  //     statusCode: response.statusCode,
  //     statusMessage: response.statusMessage,
  //     isRedirect: response.isRedirect,
  //     redirects: response.redirects,
  //     extra: response.extra,
  //     headers: response.headers,
  //   );
  // }

  /// Adds a method and responseType to the [Options] if they are absent.
  Options checkOptions({
    Options? options,
    String? method,
    ResponseType? responseType,
  }) =>
      (options ?? Options())
          .copyWith(method: method, responseType: responseType);
}
