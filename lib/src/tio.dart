import 'package:dio/dio.dart';

import 'factory_config.dart';
import 'response.dart';
import 'tio_mixin.dart';
import 'tio_transform_mixin.dart';
import 'typedefs.dart';

class Tio<E> with TioMixin<E>, TioTransformMixin<E> {
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

  @override
  final TioFactoryConfig<E> factoryConfig;

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
      rethrow;
    }
  }

  /// Adds a method and responseType to the [Options] if they are absent.
  static Options? checkOptions({
    Options? options,
    String? method,
    ResponseType? responseType,
  }) =>
      (options ?? Options())
          .copyWith(method: method, responseType: responseType);
}
