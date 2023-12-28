import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'client.dart';
import 'response.dart';
import 'typedefs.dart';

class TioRequestProxy<T, ERR> {
  const TioRequestProxy(
    this.client,
    this.path, {
    required this.method,
    this.data,
    this.queryParameters,
    this.options,
    this.cancelToken,
    this.onSendProgress,
    this.onReceiveProgress,
    // this.extra,
  });

  final Tio<ERR> client;

  final String path;
  final String method;
  final Object? data;
  final JSON? queryParameters;
  final Options? options;
  final CancelToken? cancelToken;
  final ProgressCallback? onSendProgress;
  final ProgressCallback? onReceiveProgress;
  // final TioRequestExtra? extra;

  Future<TioResponse<R, ERR>> _call<R, D>(
    ResponseType responseType,
    TioResponseTransformer<R, ERR, D> transformer,
  ) =>
      client.request<R, D>(
        path,
        transformer,
        data: data,
        queryParameters: queryParameters,
        options: client.checkOptions(
          options: options,
          method: method,
          responseType: responseType,
        ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        // extra: extra,
      );

  Future<TioResponse<T, ERR>> one() =>
      _call<T, JSON>(ResponseType.json, client.transformOne);

  Future<TioResponse<List<T>, ERR>> many() =>
      _call<List<T>, List<dynamic>>(ResponseType.json, client.transformMany);

  Future<TioResponse<Uint8List, ERR>> bytes() =>
      _call(ResponseType.bytes, client.transformBytes);

  Future<TioResponse<ResponseBody, ERR>> stream() =>
      _call(ResponseType.stream, client.transformStream);

  Future<TioResponse<String, ERR>> string() =>
      _call(ResponseType.plain, client.transformString);

  Future<TioResponse<void, ERR>> empty() =>
      _call(ResponseType.plain, client.transformEmpty);
}
