import 'package:dio/dio.dart';

import 'client.dart';
import 'request_proxy.dart';
import 'typedefs.dart';

extension TioClientX<ERR> on Tio<ERR> {
  TioRequestProxy<R, ERR> get<R>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    // TioRequestExtra? extra,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) =>
      TioRequestProxy(
        this,
        path,
        method: 'GET',
        data: data,
        queryParameters: queryParameters,
        options: options,
        // extra: extra,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

  TioRequestProxy<R, ERR> post<R>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    // TioRequestExtra? extra,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) =>
      TioRequestProxy(
        this,
        path,
        method: 'POST',
        data: data,
        queryParameters: queryParameters,
        options: options,
        // extra: extra,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );

  TioRequestProxy<R, ERR> put<R>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    // TioRequestExtra? extra,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      TioRequestProxy(
        this,
        path,
        method: 'PUT',
        data: data,
        queryParameters: queryParameters,
        options: options,
        // extra: extra,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );

  TioRequestProxy<R, ERR> patch<R>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    // TioRequestExtra? extra,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      TioRequestProxy(
        this,
        path,
        method: 'PATCH',
        data: data,
        queryParameters: queryParameters,
        options: options,
        // extra: extra,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );

  TioRequestProxy<R, ERR> delete<R>(
    String path, {
    Object? data,
    JSON? queryParameters,
    Options? options,
    // TioRequestExtra? extra,
    CancelToken? cancelToken,
  }) =>
      TioRequestProxy(
        this,
        path,
        method: 'DELETE',
        data: data,
        queryParameters: queryParameters,
        options: options,
        // extra: extra,
        cancelToken: cancelToken,
      );
}
