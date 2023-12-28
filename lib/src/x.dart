import 'dart:io';

import 'package:dio/dio.dart';

extension ListX on List<dynamic> {
  bool check<R>() => every((item) => item is R);

  List<R>? castChecked<R>() => check<R>() ? List<R>.from(this) : null;
}

extension ResponseX<T> on Response<T> {
  ContentType? get contentType {
    final value = headers[Headers.contentTypeHeader]?.firstOrNull;
    if (value != null) {
      return ContentType.parse(value);
    }
    return null;
  }
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
