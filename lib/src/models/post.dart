import 'user.dart';

class Post {
  final String text;
  final String body;
  final int id;
  final User user;
  final String updatedAt;

  Post({String text, String body, num id, this.user, this.updatedAt})
      : this.text = text,
        this.body = body,
        this.id = id;

  Post.fromJson(Map<String, dynamic> parsedJson)
      : this.text = parsedJson['text'],
        this.body = parsedJson['body'],
        this.updatedAt = parsedJson['updatedAt'],
        this.id = parsedJson['id'],
        this.user = User.fromJson(parsedJson['user']);
}
