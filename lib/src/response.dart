import 'package:dio/dio.dart';

import 'typedefs.dart';

sealed class TioResponse<T, E> {
  const TioResponse._({required this.response});

  const factory TioResponse.success({
    required Response<dynamic>? response,
    required T result,
  }) = TioSuccess._;

  const factory TioResponse.failure({
    required Response<dynamic>? response,
    required E error,
  }) = TioFailure._;

  final Response<dynamic>? response;

  TioResponse<R, E> withSuccess<R>(
    TioResultTransformer<T, E, R> builder,
  ) {
    return switch (this) {
      final TioSuccess<T, E> success => TioResponse<R, E>.success(
          response: response,
          result: builder(success),
        ),
      final TioFailure<T, E> failure => TioResponse<R, E>.failure(
          response: response,
          error: failure.error,
        ),
    };
  }
}

final class TioSuccess<T, E> extends TioResponse<T, E> {
  const TioSuccess._({required super.response, required this.result})
      : super._();

  final T result;

  @override
  String toString() {
    return '''
    TioSuccess
    result: $result
    statusCode: ${response?.statusCode}
    ''';
  }
}

final class TioFailure<T, E> extends TioResponse<T, E> {
  const TioFailure._({required super.response, required this.error})
      : super._();

  final E error;

  // coverage:ignore-start
  @override
  String toString() {
    return '''
    TioFailure
    error: $error
    statusCode: ${response?.statusCode}
    ''';
  }
// coverage:ignore-end
}
