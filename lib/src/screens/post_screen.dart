import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/models/post.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_meetuper/src/widgets/bottom_navigation.dart';

class PostScreen extends StatefulWidget {
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

  void _fetchPosts() {
    http.get('https://jsonplaceholder.typicode.com/posts').then((res) {
      final List<dynamic> parsedPosts = json.decode(res.body);
      final posts =
          parsedPosts.map((parsedPost) => Post.fromJson(parsedPost)).toList();
      setState(() => _posts = posts);
    });
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
        tooltip: 'Increment',
        onPressed: () {},
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
