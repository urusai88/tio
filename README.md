A simple wrapper for [dio](https://pub.dev/packages/dio) with response typing and full backward compatibility.   
Inspired by [chopper](https://pub.dev/packages/chopper).

> This package currently in beta. Use it with caution.

<a href="https://github.com/urusai88/tio/actions"><img src="https://github.com/urusai88/tio/workflows/Build/badge.svg" alt="Build Status"></a>
[![codecov](https://codecov.io/gh/urusai88/tio/branch/main/graph/badge.svg)](https://codecov.io/gh/urusai88/tio)

## Features

- Safe typing of successful and unsuccessful responses.
- Expected behavior.
- Does not affect basic Dio functionality including other plugins or interceptors.
- Simple and familiar Dio like api.
- Core concept is receiving a response as either type to utilize the exhaustive pattern.
- No external dependencies.
 
#### Basic usage:

```dart
import 'package:tio/tio.dart'; // 'package:dio.dio.dart' imports implicitly.

class User {
  User.fromJson(Map<String, dynamic> json) : id = json['id'] as int;

  final int id;
}

class MyError {
  const MyError.fromString(this.errorMessage);

  const MyError.empty() : errorMessage = 'Unknown message';

  MyError.fromJson(Map<String, dynamic> json) : errorMessage = json['message'] as String;

  final String errorMessage;
}

const factoryConfig = TioFactoryConfig<MyError>(
  [
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

void main() async {
  switch (await getUser(1)) {
    case TioSuccess<User, MyError>(result: final user):
      print('user id is ${user.id}');
    case TioFailure<User, MyError>(error: final error):
      print('error acquired ${error.errorMessage}');
  }
}

```

## Guide

#### Common

`Tio` mirrors the common methods of `Dio` such as `get`, `post`, `put` etc. but returns proxy object as a result that might be transformed by additional methods like `one()`, `many()`, `string()` etc.

```dart
Future<TioResponse<User, MyError>> getUser(int id) =>
    tio.get<User>('/users/$id').one();

Future<TioResponse<List<User>, MyError>> getUsers() =>
    tio.get<User>('/users').many();

Future<TioResponse<User, MyError>> updateUser(int id, String name) =>
    tio.post<User>('/users/$id', data: {'name': name}).one();

Future<TioResponse<String, MyError>> getString() =>
    tio.get<String>('/text').string();
```

#### Using TioApi helper class [Optional]
```dart
class UserApi extends TioApi<MyError> {
    UserApi({required super.tio}) : super(path: '/users');

    Future<TioResponse<User, MyError>> getUser(int id) =>
        get<User>('/$id').one();

    Future<TioResponse<List<User>, MyError>> getUsers() =>
        get<User>('/').many();
}
```

#### How Tio knows that response is unsuccessful?

With the `Options.validateStatus` property.  
Tio transforms any `DioException` with type `badResposce` into an `ErrorT` then returns `TioFailure<..., ErrorT>` instead of throwing an exception.

#### Tips & Tricks

Alias usage to slightly reduce code size.

```dart
typedef MyResponse<T> = TioResponse<T, MyError>;

Future<MyResponse<User>> getUser(int id) =>
    tio.get<User>('/users/$id').one();
```

Check tests for additional usage info.

Initially this library was created for personal usage.
