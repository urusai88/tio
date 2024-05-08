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

  TioResponse<R, E> withSuccess<R>(TioResultTransformer<T, E, R> builder);

  R map<R>({
    required R Function(TioSuccess<T, E> success) success,
    required R Function(TioFailure<T, E> failure) failure,
  });
}

final class TioSuccess<T, E> extends TioResponse<T, E> {
  const TioSuccess._({required super.response, required this.result})
      : super._();

  final T result;

  @override
  TioResponse<R, E> withSuccess<R>(TioResultTransformer<T, E, R> builder) =>
      TioResponse<R, E>.success(response: response, result: builder(this));

  @override
  R map<R>({
    required R Function(TioSuccess<T, E> success) success,
    required R Function(TioFailure<T, E> failure) failure,
  }) =>
      success(this);

  @override
  String toString() {
    final content = [
      'result: $result',
      'statusCode: ${response?.statusCode}',
    ].join(', ');
    return 'TioSuccess($content)';
  }
}

final class TioFailure<T, E> extends TioResponse<T, E> {
  const TioFailure._({required super.response, required this.error})
      : super._();

  final E error;

  @override
  TioResponse<R, E> withSuccess<R>(TioResultTransformer<T, E, R> builder) =>
      TioResponse<R, E>.failure(response: response, error: error);

  @override
  R map<R>({
    required R Function(TioSuccess<T, E> success) success,
    required R Function(TioFailure<T, E> failure) failure,
  }) =>
      failure(this);

  @override
  String toString() {
    final content = [
      'error: $error',
      'statusCode: ${response?.statusCode}',
    ].join(', ');
    return 'TioFailure($content)';
  }
}
