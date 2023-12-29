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
  const TioError.config({this.message, this.stackTrace})
      // ignore: avoid_field_initializers_in_const_classes
      : type = TioErrorType.config;

  final TioErrorType type;

  final String? message;

  @override
  final StackTrace? stackTrace;

  // coverage:ignore-start
  @override
  String toString() {
    final outputs = ['TioError($message, $type)'];

    if (stackTrace != null) {
      outputs.add('innerStackTrace:');
      outputs.add('$stackTrace');
    }

    return outputs.join('\n');
  }
// coverage:ignore-end
}

class TioException implements Exception {
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

  // coverage:ignore-start
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
// coverage:ignore-end
}
