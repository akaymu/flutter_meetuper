import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostApiProvider {
  Future<List<Post>> fetchPosts() async {
    final res = await http.get('https://jsonplaceholder.typicode.com/posts');
    final List<dynamic> parsedPosts = json.decode(res.body);

    return parsedPosts.map((parsedPost) => Post.fromJson(parsedPost)).toList();
  }
}
