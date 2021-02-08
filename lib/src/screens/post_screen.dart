import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_meetuper/src/widgets/bottom_navigation.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    http.get('https://jsonplaceholder.typicode.com/posts').then((res) {
      final posts = json.decode(res.body);
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
  final List<dynamic> _posts;
  _PostList({List<dynamic> posts}) : _posts = posts;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _posts.map((post) {
        return ListTile(
          title: Text(post['title']),
          subtitle: Text(post['body']),
        );
      }).toList(),
    );
  }
}
