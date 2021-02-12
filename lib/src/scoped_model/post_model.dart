import 'package:faker/faker.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/post.dart';
import '../services/post_api_provider.dart';

class PostModel extends Model {
  List<Post> posts = [];
  final testingState = 'Testing State';
  final PostApiProvider _api = PostApiProvider();

  PostModel() {
    _fetchPosts();
  }

  void addPost() {
    final id = faker.randomGenerator.integer(9999);
    final title = faker.food.dish();
    final body = faker.food.cuisine();
    final newPost = Post(id: id, title: title, body: body);

    posts.add(newPost);
    notifyListeners();
  }

  void _fetchPosts() async {
    final List<Post> posts = await _api.fetchPosts();
    this.posts = posts;
    notifyListeners();
  }
}
