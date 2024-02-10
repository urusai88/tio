import 'client.dart';

/// Helper class
class TioService<E> {
  const TioService({required this.tio, this.path = '/'});

  final Tio<E> tio;
  final String path;
}
