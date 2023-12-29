import 'dart:typed_data';

import 'package:tio/tio.dart';

import '_entities.dart';
import '_typedefs.dart';

class TestTioService extends TioService<MyResponseError> {
  const TestTioService({required super.client});

  Future<MyResponse<void>> long(CancelToken cancelToken) =>
      client.get<void>('/long_job', cancelToken: cancelToken).empty();

  Future<MyResponse<List<Post>>> posts() => client.get<Post>('/posts').many();

  Future<MyResponse<List<User>>> postsAsUsers() =>
      client.get<User>('/posts').many();

  Future<MyResponse<User>> postAsUser(int id) =>
      client.get<User>('/posts/$id').one();

  Future<MyResponse<List<Todo>>> todos() => client.get<Todo>('/todos').many();

  Future<MyResponse<ResponseBody>> todosAsStream() =>
      client.get<ResponseBody>('/todos').stream();

  Future<MyResponse<String>> todosAsString() =>
      client.get<String>('/todos').string();

  Future<MyResponse<Uint8List>> todosAsBytes() =>
      client.get<String>('/todos').bytes();

  Future<MyResponse<void>> todosAsEmpty() => client.get<void>('/todos').empty();

  Future<MyResponse<Todo>> todo(int id) => client.get<Todo>('/todos/$id').one();

  Future<MyResponse<User>> user(int id, {bool enableAuth = true}) => client
      .get<User>('/users/$id', options: Options()..enableAuth = enableAuth)
      .one();

  Future<MyResponse<String>> checkAccessToken() =>
      client.get<String>('/check_access_token').string();

  Future<MyResponse<RefreshTokenResponse>> refreshAccessToken() =>
      client.get<RefreshTokenResponse>('/refresh_access_token').one();

  Future<MyResponse<User>> error404empty() =>
      client.get<User>('/404_empty').one();

  Future<MyResponse<User>> error404string() =>
      client.get<User>('/404_string').one();

  Future<MyResponse<User>> error404json() =>
      client.get<User>('/404_json').one();
}
