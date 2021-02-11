import 'package:flutter/material.dart';
import 'package:faker/faker.dart';

import '../models/post.dart';
import '../services/post_api_provider.dart';
import '../widgets/bottom_navigation.dart';

class PostScreen extends StatefulWidget {
  final PostApiProvider _api = PostApiProvider();

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final List<Post> posts = await widget._api.fetchPosts();
    setState(() => _posts = posts);
  }

  void _addPost() {
    final id = faker.randomGenerator.integer(9999);
    final title = faker.food.dish();
    final body = faker.food.cuisine();
    final newPost = Post(id: id, title: title, body: body);

    setState(() => _posts.add(newPost));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: _PostList(posts: _posts),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Add Post',
        onPressed: _addPost,
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

class _PostList extends StatelessWidget {
  final List<Post> _posts;
  _PostList({List<dynamic> posts}) : _posts = posts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _posts.length * 2,
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) {
          return Divider();
        }

        final int index = i ~/ 2;

        return ListTile(
          title: Text(_posts[index].title),
          subtitle: Text(_posts[index].body),
        );
      },
    );
  }
}
