// ignore_for_file: avoid_print
import 'package:tio/tio.dart'; // 'package:dio.dio.dart' imports implicitly.

class User {
  User.fromJson(Map<String, dynamic> json) : id = json['id'] as int;

  final int id;
}

class MyError {
  const MyError.fromString(this.errorMessage);

  const MyError.empty() : errorMessage = 'Unknown message';

  MyError.fromJson(JSON json) : errorMessage = json['message'] as String;

  final String errorMessage;
}

const factoryConfig = TioFactoryConfig<MyError>(
  jsonFactoryList: [
    TioJsonFactory<User>(User.fromJson),
  ],
  // Factory for error transformation
  errorGroup: TioFactoryGroup(
    // when response body is empty (or empty string)
    empty: TioEmptyFactory(MyError.empty),
    string: TioStringFactory(MyError.fromString), // string
    json: TioJsonFactory(MyError.fromJson), // or json
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
