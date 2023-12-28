import 'typedefs.dart';

class TioFactoryGroup<ERR> {
  const TioFactoryGroup({
    required this.empty,
    required this.string,
    required this.json,
  });

  final TioEmptyFactory<ERR> empty;
  final TioStringFactory<ERR> string;
  final TioJsonFactory<ERR> json;
}

class TioFactoryConfig<ERR> {
  const TioFactoryConfig({
    required this.jsonFactoryList,
    required this.errorGroup,
  });

  final List<TioJsonFactory<dynamic>> jsonFactoryList;
  final TioFactoryGroup<ERR> errorGroup;

  TioJsonFactory<T>? get<T>() =>
      jsonFactoryList.whereType<TioJsonFactory<T>>().firstOrNull;

  bool contains<T>() =>
      jsonFactoryList.whereType<TioJsonFactory<T>>().isNotEmpty;
}
