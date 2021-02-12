import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:flutter_meetuper/src/state/app_state.dart';

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
    return _InheritedPost(
      posts: _posts,
      createPost: _addPost,
      child: _PostList(),
    );
  }
}

class _InheritedPost extends InheritedWidget {
  final Widget child;
  final List<Post> posts;
  final Function createPost;

  _InheritedPost({
    @required this.child,
    @required this.posts,
    @required this.createPost,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static _InheritedPost of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedPost>();
  }
}

class _PostList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final posts = _InheritedPost.of(context).posts;
    final testingData = AppStore.of(context).testingData2;

    return Scaffold(
      appBar: AppBar(
        title: Text(testingData),
      ),
      body: ListView.builder(
        itemCount: posts.length * 2,
        itemBuilder: (BuildContext context, int i) {
          if (i.isOdd) {
            return Divider();
          }

          final int index = i ~/ 2;

          return ListTile(
            title: Text(posts[index].title),
            subtitle: Text(posts[index].body),
          );
        },
      ),
      floatingActionButton: _PostButton(),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

class _PostButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      tooltip: 'Add Post',
      onPressed: _InheritedPost.of(context).createPost,
    );
  }
}
