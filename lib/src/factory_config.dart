import 'typedefs.dart';

class TioFactoryGroup<E> {
  const TioFactoryGroup({
    required this.string,
    required this.json,
  });

  final TioStringFactory<E> string;
  final TioJsonFactory<E> json;
}

class TioFactoryConfig<E> {
  const TioFactoryConfig({
    this.list = const {},
    required this.errorStringFactory,
    required this.errorJsonFactory,
  });

  final Set<TioJsonFactory<dynamic>> list;

  final TioStringFactory<E> errorStringFactory;
  final TioJsonFactory<E> errorJsonFactory;

  List<Type> get containsFactories => list.map(_genericTypeFactory).toList();

  TioJsonFactory<T>? get<T>() =>
      list.whereType<TioJsonFactory<T>>().firstOrNull;

  bool contains<T>() => get<T>() != null;
}

Type _genericTypeFactory<T>(TioJsonFactory<T> factory) => T;
