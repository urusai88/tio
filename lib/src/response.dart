import 'package:dio/dio.dart';

import 'typedefs.dart';

sealed class TioResponse<R, ERR> {
  const TioResponse._({required this.response});

  const factory TioResponse.success({
    required Response<dynamic>? response,
    required R result,
  }) = TioSuccess._;

  const factory TioResponse.failure({
    required Response<dynamic>? response,
    required ERR error,
  }) = TioFailure._;

  final Response<dynamic>? response;

  TioResponse<R1, ERR> withSuccess<R1>(
    TioResultTransformer<R, ERR, R1> builder,
  ) {
    return switch (this) {
      final TioSuccess<R, ERR> success => TioResponse<R1, ERR>.success(
          response: response,
          result: builder(success),
        ),
      final TioFailure<R, ERR> failure => TioResponse<R1, ERR>.failure(
          response: response,
          error: failure.error,
        ),
    };
  }
}

final class TioSuccess<R, ERR> extends TioResponse<R, ERR> {
  const TioSuccess._({required super.response, required this.result})
      : super._();

  final R result;

  @override
  String toString() {
    return '''
    TioSuccess
    result: $result
    statusCode: ${response?.statusCode}
    ''';
  }
}

final class TioFailure<R, ERR> extends TioResponse<R, ERR> {
  const TioFailure._({required super.response, required this.error})
      : super._();

  final ERR error;

  @override
  String toString() {
    return '''
    TioFailure
    error: $error
    statusCode: ${response?.statusCode}
    ''';
  }
}
