import 'package:equatable/equatable.dart';

import '../typedefs.dart';

mixin TioResponseMixin<R, E> {
  T map<T>({
    required T Function(TioSuccess<R, E> success) success,
    required T Function(TioFailure<R, E> failure) failure,
  }) =>
      switch (this) {
        final TioSuccess<R, E> value => success(value),
        final TioFailure<R, E> value => failure(value),
        _ => throw StateError('Bad state'),
      };

  T when<T>({
    required T Function(R result) success,
    required T Function(E error) failure,
  }) =>
      switch (this) {
        final TioSuccess<R, E> value => success(value.result),
        final TioFailure<R, E> value => failure(value.error),
        _ => throw StateError('Bad state'),
      };
}

abstract class TioResponse<R, E> with EquatableMixin, TioResponseMixin<R, E> {
  const TioResponse();

  const factory TioResponse.success({required R result}) = TioSuccess;

  const factory TioResponse.failure({required E error}) = TioFailure;

  TioResponse<T, E> withSuccess<T>(TioResultTransformer<R, E, T> builder);

  R get requireResult => map(
        success: (success) => success.result,
        failure: (_) => throw StateError('Response is not success'),
      );

  bool get isSuccess => this is TioSuccess;

  bool get isFailure => this is TioFailure;
}

class TioSuccess<R, E> extends TioResponse<R, E> {
  const TioSuccess({required this.result});

  final R result;

  @override
  TioResponse<T, E> withSuccess<T>(TioResultTransformer<R, E, T> builder) =>
      TioResponse<T, E>.success(result: builder(this));

  @override
  List<Object?> get props => [result];
}

class TioFailure<R, E> extends TioResponse<R, E> {
  const TioFailure({required this.error});

  final E error;

  @override
  TioResponse<T, E> withSuccess<T>(TioResultTransformer<R, E, T> builder) =>
      TioResponse<T, E>.failure(error: error);

  @override
  List<Object?> get props => [error];
}
