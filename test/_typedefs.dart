import 'package:equatable/equatable.dart';
import 'package:tio/tio.dart';

import '_internal.dart';

class MyResponseError with EquatableMixin {
  const MyResponseError.fromString(this.message);

  const MyResponseError.empty() : message = errorEmpty;

  MyResponseError.fromJson(JsonMap json) : message = json['message'] as String;

  final String message;

  @override
  List<Object?> get props => [message];
}

typedef MyResponse<R> = TioResponse<R, MyResponseError>;
typedef MySuccess<R> = TioSuccess<R, MyResponseError>;
typedef MyFailure<R> = TioFailure<R, MyResponseError>;
