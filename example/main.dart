// ignore_for_file: avoid_print

import 'package:tio/tio.dart'; // 'package:dio.dio.dart' imports implicitly.

class User {
  User.fromJson(Map<String, dynamic> json) : id = json['id'] as int;

  final int id;
}

class MyError {
  const MyError(this.errorMessage);

  MyError.fromJson(Map<String, dynamic> json)
      : errorMessage = json['error_message'] as String;

  final String errorMessage;
}

final factoryConfig = TioFactoryConfig<MyError>(
  jsonFactoryList: const [
    TioJsonFactory(User.fromJson),
  ],
  // Factory for error transformation
  errorGroup: TioFactoryGroup(
    empty: (response) =>
        const MyError('Unknown error'), // when responce body is empty
    string: MyError.new, // string
    json: const TioJsonFactory(MyError.fromJson), // or json
  ),
);

final dio = Dio();
final tio = Tio<MyError>(
  dio: dio, // Tio uses dio under the hood
  factoryConfig: factoryConfig,
);

Future<TioResponse<User, MyError>> getUser(int id) =>
    tio.get<User>('/users/$id').one();

Future<TioResponse<List<User>, MyError>> getUsers() =>
    tio.get<User>('/users').many();

Future<TioResponse<User, MyError>> updateUser(int id, String name) =>
    tio.post<User>('/users/$id', data: {'name': name}).one();

Future<TioResponse<String, MyError>> geString() =>
    tio.get<String>('/text').string();
void main() async {
  switch (await getUser(1)) {
    case TioSuccess<User, MyError>(result: final user):
      print('user id is ${user.id}');
    case TioFailure<User, MyError>(error: final error):
      print('error acquired ${error.errorMessage}');
  }
}
