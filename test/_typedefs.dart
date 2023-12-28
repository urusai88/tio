import 'package:tio/tio.dart';

class MyResponseError {
  const MyResponseError(this.message);

  MyResponseError.fromJson(JSON json) : message = json['message'] as String;

  final String message;
}

typedef MyResponse<R> = TioResponse<R, MyResponseError>;
typedef MySuccess<R> = TioSuccess<R, MyResponseError>;
typedef MyFailure<R> = TioFailure<R, MyResponseError>;
