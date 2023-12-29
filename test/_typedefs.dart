import 'package:equatable/equatable.dart';
import 'package:tio/tio.dart';

class MyResponseError with EquatableMixin {
  const MyResponseError(this.message);

  MyResponseError.fromJson(JSON json) : message = json['message'] as String;

  final String message;

  @override
  List<Object?> get props => [message];
}

typedef MyResponse<R> = TioResponse<R, MyResponseError>;
typedef MySuccess<R> = TioSuccess<R, MyResponseError>;
typedef MyFailure<R> = TioFailure<R, MyResponseError>;
