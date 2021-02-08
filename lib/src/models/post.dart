import 'dart:convert';

class Post {
  final int id;
  final String title;
  final String body;

  Post({String title, String body, int id})
      : this.title = title,
        this.body = body,
        this.id = id;

  Post.fromJson(Map<String, dynamic> parsedJson)
      : title = parsedJson['title'] ?? '',
        body = parsedJson['body'] ?? '',
        id = parsedJson['id'] ?? 0;
}
