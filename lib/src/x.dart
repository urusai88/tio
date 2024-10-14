import 'package:dio/dio.dart';

import 'response.dart';

extension ListX on List<dynamic> {
  /// Checks every item is type of T.
  bool check<T>() => every((item) => item is T);

  /// Cast self to List<T> if every item is type of T.
  /// Otherwise returns null.
  List<T>? castChecked<T>() => check<T>() ? List<T>.from(this) : null;
}

extension RequestOptionsX on RequestOptions {
  Options toOptions() {
    return Options(
      method: method,
      sendTimeout: sendTimeout,
      receiveTimeout: receiveTimeout,
      extra: extra,
      headers: headers,
      preserveHeaderCase: preserveHeaderCase,
      responseType: responseType,
      contentType: contentType,
      validateStatus: validateStatus,
      receiveDataWhenStatusError: receiveDataWhenStatusError,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
      persistentConnection: persistentConnection,
      requestEncoder: requestEncoder,
      responseDecoder: responseDecoder,
      listFormat: listFormat,
    );
  }
}

extension DioX on Dio {
  Future<Response<T>> restart<T>(Response<T> originalResponse) {
    final requestOptions = originalResponse.requestOptions;
    return request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      cancelToken: requestOptions.cancelToken,
      options: requestOptions.toOptions(),
      onSendProgress: requestOptions.onSendProgress,
      onReceiveProgress: requestOptions.onReceiveProgress,
    );
  }
}

extension FutureTioResponseX<T, E> on Future<TioResponse<T, E>> {
  Future<R> map<R>({
    required R Function(TioSuccess<T, E> success) success,
    required R Function(TioFailure<T, E> failure) failure,
  }) =>
      then((response) => response.map(success: success, failure: failure));
}
