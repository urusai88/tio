sealed class TioError {
  const TioError._();

  const factory TioError.config() = TioConfigError._;

  const factory TioError.transform() = TioTransformError._;
}

class TioConfigError extends TioError {
  const TioConfigError._() : super._();
}

class TioTransformError extends TioError {
  const TioTransformError._() : super._();
}
