import 'package:dio/dio.dart';

import 'factory_config.dart';
import 'response.dart';
import 'tio.dart';
import 'tio_mixin.dart';
import 'tio_transform_mixin.dart';
import 'typedefs.dart';

/// Helper class
class TioApi<E> with TioMixin<E>, TioTransformMixin<E> {
  const TioApi({required this.tio, this.path = '/'});

  final Tio<E> tio;
  final String path;

  @override
  TioFactoryConfig<E> get factoryConfig => tio.factoryConfig;

  @override
  Future<TioResponse<T, E>> request<T, D>(
    String path,
    TioResponseTransformer<T, E, D> transformer, {
    Object? data,
    JSON? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) =>
      tio.request(
        _normalizePath(path),
        transformer,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

  String _normalizePath(String path) {
    if (path.isNotEmpty) {
      if (!path.startsWith('/')) {
        path = '/$path';
      }
    }
    if (path == '/') {
      path = '';
    }
    return '${this.path}$path';
  }
}
