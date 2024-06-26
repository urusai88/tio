import 'package:dio/dio.dart';

import 'interfaces/tio_base.dart';
import 'request_proxy.dart';
import 'typedefs.dart';

mixin TioMixin<E> implements TioBase<E> {
  TioRequestProxy<T, E> get<T>(
    String path, {
    Object? data,
    JsonMap? queryParameters,
    Options? options,
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
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

  TioRequestProxy<T, E> post<T>(
    String path, {
    Object? data,
    JsonMap? queryParameters,
    Options? options,
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
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );

  TioRequestProxy<T, E> put<T>(
    String path, {
    Object? data,
    JsonMap? queryParameters,
    Options? options,
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
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );

  TioRequestProxy<T, E> head<T>(
    String path, {
    Object? data,
    JsonMap? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) =>
      TioRequestProxy(
        this,
        path,
        method: 'HEAD',
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

  TioRequestProxy<T, E> patch<T>(
    String path, {
    Object? data,
    JsonMap? queryParameters,
    Options? options,
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
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );

  TioRequestProxy<T, E> delete<T>(
    String path, {
    Object? data,
    JsonMap? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) =>
      TioRequestProxy(
        this,
        path,
        method: 'DELETE',
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
}
