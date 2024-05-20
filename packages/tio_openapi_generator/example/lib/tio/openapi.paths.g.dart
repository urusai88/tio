abstract interface class OthersApi {
  const OthersApi();

  Future<String> version();
  Future<({({String city}) current_address})> orders();
}

class OthersHttpApi implements OthersApi {
  const OthersHttpApi();

  @override
  Future<String> version();
  @override
  Future<({({String city}) current_address})> orders();
}

abstract interface class UsersApi {
  const UsersApi();

  Future<List<UserSchema>> list();
  Future<UserSchema> get({required int id});
}

class UsersHttpApi implements UsersApi {
  const UsersHttpApi();

  @override
  Future<List<UserSchema>> list();
  @override
  Future<UserSchema> get({required int id});
}
