import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostApiProvider {
  // Private Costructor
  PostApiProvider._();

  // Static singleton and factory constructor
  static final PostApiProvider _singleton = PostApiProvider._();
  factory PostApiProvider() => _singleton;

  Future<List<Post>> fetchPosts() async {
    final res = await http.get('https://jsonplaceholder.typicode.com/posts');
    final List<dynamic> parsedPosts = json.decode(res.body);

    return parsedPosts
        .map((parsedPost) => Post.fromJson(parsedPost))
        .take(2)
        .toList();
  }
}
