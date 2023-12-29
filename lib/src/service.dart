import 'client.dart';

/// Helper class
class TioService<E> {
  const TioService({required this.client, this.path = '/'});

  final Tio<E> client;

  final String path;
}
