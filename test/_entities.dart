import 'package:equatable/equatable.dart';
import 'package:tio/src/typedefs.dart';
import 'package:tio/tio.dart';

abstract interface class HasId {
  int get id;
}

class User with EquatableMixin implements HasId {
  const User({required this.id, required this.name, required this.accessToken});

  User.fromJson(JSON json)
      : id = json['id'] as int,
        name = json['name'] as String,
        accessToken = json['accessToken'] as String;

  @override
  final int id;
  final String name;
  final String accessToken;

  JSON toJson() => {'id': id, 'name': name, 'accessToken': accessToken};

  @override
  List<Object?> get props => [id, name];
}

class Todo with EquatableMixin implements HasId {
  const Todo({required this.id, required this.userId});

  Todo.fromJson(JSON json)
      : id = json['id'] as int,
        userId = json['userId'] as int;

  @override
  final int id;
  final int userId;

  JSON toJson() => {'id': id, 'userId': userId};

  @override
  List<Object?> get props => [id, userId];
}

class Post with EquatableMixin implements HasId {
  const Post({required this.id, required this.userId, required this.body});

  @override
  final int id;
  final int userId;
  final String body;

  JSON toJson() => {'id': id, 'userId': userId, 'body': body};

  @override
  List<Object?> get props => [id, userId, body];
}

const users = <User>[
  User(id: 1, name: 'Frank', accessToken: 'FrankAccessToken'),
  User(id: 2, name: 'Marie', accessToken: 'MarieAccessToken'),
];

const todos = <Todo>[
  Todo(id: 1, userId: 2),
  Todo(id: 2, userId: 1),
];

const posts = <Post>[
  Post(id: 1, userId: 1, body: 'example post body'),
];

class RefreshTokenResponse {
  const RefreshTokenResponse({required this.a, required this.r});

  RefreshTokenResponse.fromJson(JSON json)
      : a = json['a'] as String,
        r = json['r'] as String;

  final String a;
  final String r;

  JSON toJson() => {'a': a, 'r': r};
}
