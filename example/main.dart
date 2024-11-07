import 'package:dio/dio.dart';
import 'package:tio/tio.dart';

class User {
  User.fromJson(JsonMap json) : id = json['id'] as int;

  final int id;
}

class MyError {
  const MyError.fromString(this.errorMessage);

  const MyError.empty() : errorMessage = 'Unknown message';

  MyError.fromJson(JsonMap json) : errorMessage = json['message'] as String;

  final String errorMessage;
}

const factoryConfig = TioFactoryConfig<MyError>(
  list: {
    User.fromJson,
  },
  errorJsonFactory: MyError.fromJson,
  errorStringFactory: MyError.fromString,
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
