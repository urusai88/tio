import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../response.dart';
import '../typedefs.dart';

abstract interface class TioBase<E> {
  TioResponse<T, E> transformOne<T>(Response<JsonMap> resp);

  TioResponse<List<T>, E> transformMany<T>(Response<List<dynamic>> resp);

  TioResponse<void, E> transformEmpty(Response<dynamic> resp);

  E transformError(Response<dynamic> resp);

  TioResponse<String, E> transformString(Response<String> resp);

  TioResponse<Uint8List, E> transformBytes(Response<Uint8List> resp);

  TioResponse<ResponseBody, E> transformStream(Response<ResponseBody> resp);

  Future<TioResponse<T, E>> request<T, D>(
    String path,
    TioResponseTransformer<T, E, D> transformer, {
    Object? data,
    JsonMap? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });
}
