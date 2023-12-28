import 'package:dio/dio.dart';

enum TioErrorType {
  /// Factory for type is absent.
  config,
}

enum TioExceptionType {
  /// [DioException] except [DioException.badResponse].
  dio,

  /// Typically is transformation (deserialization) stage error.
  /// In debug check you code and server response.
  /// In runtime can be handled like server error.
  middleware,
}

class TioError implements Error {
  const TioError({required this.type, this.message, this.stackTrace});

  const TioError.config({this.message, this.stackTrace})
      : type = TioErrorType.config;

  final TioErrorType type;

  final String? message;

  @override
  final StackTrace? stackTrace;

  @override
  String toString() {
    final outputs = ['TioError($message, $type)'];

    if (stackTrace != null) {
      outputs.add('innerStackTrace:');
      outputs.add('$stackTrace');
    }

    return outputs.join('\n');
  }
}

class TioException implements Exception {
  const TioException._({
    required this.type,
    this.message,
    this.stackTrace,
    this.dioException,
  });

  const TioException.dio({
    this.message,
    this.stackTrace,
    required DioException this.dioException,
  }) : type = TioExceptionType.dio;

  const TioException.middleware({this.message, this.stackTrace})
      : type = TioExceptionType.middleware,
        dioException = null;

  final TioExceptionType type;

  final String? message;

  final StackTrace? stackTrace;

  final DioException? dioException;

  @override
  String toString() {
    final outputs = ['TioException($message, $type)'];

    if (dioException != null) {
      outputs.add('$dioException');
    }
    if (stackTrace != null) {
      outputs.add('innerStackTrace:');
      outputs.add('$stackTrace');
    }

    return outputs.join('\n');
  }
}