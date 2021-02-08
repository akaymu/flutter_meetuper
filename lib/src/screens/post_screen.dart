import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/widgets/bottom_navigation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> _posts = [];

  @override
  void initState() {
    super.initState();

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome in Post Screen',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 15.0),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Increment',
        onPressed: () {},
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
