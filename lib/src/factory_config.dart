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
  const TioFactoryConfig({
    required this.jsonFactoryList,
    required this.errorGroup,
  });

  final List<TioJsonFactory<dynamic>> jsonFactoryList;
  final TioFactoryGroup<E> errorGroup;

  List<Type> get containsFactories =>
      jsonFactoryList.map(_genericTypeFactory).toList();

  TioJsonFactory<T>? get<T>() =>
      jsonFactoryList.whereType<TioJsonFactory<T>>().firstOrNull;

  bool contains<T>() =>
      jsonFactoryList.whereType<TioJsonFactory<T>>().isNotEmpty;
}

Type _genericTypeFactory<T>(TioJsonFactory<T> factory) => T;
