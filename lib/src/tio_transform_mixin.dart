import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'errors.dart';
import 'factory_config.dart';
import 'responses/response.dart';
import 'responses/response_http.dart';
import 'typedefs.dart';
import 'x.dart';

mixin TioTransformMixin<E> {
  TioFactoryConfig<E> get factoryConfig;

  TioResponse<String, E> transformString(Response<String> resp) =>
      TioHttpResponse<String, E>.success(
        response: resp,
        result: resp.data!,
      );

  TioResponse<Uint8List, E> transformBytes(Response<Uint8List> resp) =>
      TioHttpResponse.success(
        response: resp,
        result: resp.data!,
      );

  TioResponse<ResponseBody, E> transformStream(Response<ResponseBody> resp) =>
      TioHttpResponse.success(
        response: resp,
        result: resp.data!,
      );

  TioResponse<T, E> transformOne<T>(Response<JsonMap> resp) {
    final factory = factoryConfig.get<T>();
    final data = resp.data;
    if (factory == null) {
      _throwConfigException<T>(resp);
    }
    if (data is! JsonMap) {
      _throwTransformException(resp);
    }

    try {
      final json = JsonMap.from(data);
      return TioHttpResponse.success(
        response: resp,
        result: factory(json),
      );
    } catch (e, s) {
      _throwTransformException(resp, e, s);
    }
  }

  TioResponse<List<T>, E> transformMany<T>(Response<List<dynamic>> resp) {
    final factory = factoryConfig.get<T>();
    final json = resp.data?.castChecked<JsonMap>();
    if (factory == null) {
      _throwConfigException<T>(resp);
    }
    if (json == null) {
      _throwTransformException(resp);
    }

    try {
      final result = json.map(factory.call).toList();
      return TioHttpResponse.success(
        response: resp,
        result: result,
      );
    } catch (e, s) {
      _throwTransformException(resp, e, s);
    }
  }

  TioResponse<void, E> transformEmpty(Response<dynamic> resp) =>
      TioHttpResponse.success(response: resp, result: null);

  E transformError(Response<dynamic> resp) {
    try {
      return switch (resp.data) {
        final String string => factoryConfig.errorStringFactory(string),
        final JsonMap json => factoryConfig.errorJsonFactory(json),
        _ => factoryConfig.errorStringFactory(''),
      };
    } catch (e, s) {
      _throwTransformException(resp, e, s);
    }
  }

  Never _throwTransformException(
    Response<dynamic> response, [
    Object? error,
    StackTrace? stackTrace,
  ]) =>
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: const TioError.transform(),
        message: error?.toString(),
        stackTrace: stackTrace,
      );

  Never _throwConfigException<T>(Response<dynamic> response) {
    final containsFactories =
        factoryConfig.containsFactories.map((e) => '$e').join(', ');
    final message = '''
      Can not find factory for $T.
      Found factories for $containsFactories.
    ''';

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: const TioError.config(),
      message: message,
    );
  }
}
