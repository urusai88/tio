import 'typedefs.dart';

class TioFactoryGroup<E> {
  const TioFactoryGroup({
    required this.empty,
    required this.string,
    required this.json,
  });

  final TioEmptyFactory<E> empty;
  final TioStringFactory<E> string;
  final TioJsonFactory<E> json;
}

class TioFactoryConfig<E> {
  const TioFactoryConfig(
    List<TioJsonFactory<dynamic>> factories, {
    required this.errorGroup,
  }) : _factories = factories;

  final List<TioJsonFactory<dynamic>> _factories;
  final TioFactoryGroup<E> errorGroup;

  List<Type> get containsFactories =>
      _factories.map(_genericTypeFactory).toList();

  TioJsonFactory<T>? get<T>() =>
      _factories.whereType<TioJsonFactory<T>>().firstOrNull;

  bool contains<T>() => get<T>() != null;
}

Type _genericTypeFactory<T>(TioJsonFactory<T> factory) => T;
