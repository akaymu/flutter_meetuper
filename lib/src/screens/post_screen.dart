import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_model/post_model.dart';
import '../widgets/bottom_navigation.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<PostModel>(
      model: PostModel(),
      child: _PostList(),
    );
  }
}

class _PostList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PostModel>(
      // Veriye nasıl ulaşırız? Yöntem 1
      builder: (context, _, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(model.testingState),
          ),
          body: ListView.builder(
            itemCount: model.posts.length * 2,
            itemBuilder: (BuildContext context, int i) {
              if (i.isOdd) {
                return Divider();
              }

              final int index = i ~/ 2;

              return ListTile(
                title: Text(model.posts[index].title),
                subtitle: Text(model.posts[index].body),
              );
            },
          ),
          floatingActionButton: _PostButton(),
          bottomNavigationBar: BottomNavigation(),
        );
      },
    );
  }
}

class _PostButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Veriye nasıl ulaşırız? Yöntem 2
    final postModel = ScopedModel.of<PostModel>(context, rebuildOnChange: true);
    return FloatingActionButton(
      child: Icon(Icons.add),
      tooltip: 'Add Post',
      onPressed: postModel.addPost,
    );
  }
}
