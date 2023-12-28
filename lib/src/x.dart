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
