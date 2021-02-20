import 'post.dart';
import 'user.dart';

class Thread {
  final String title;
  final User user;
  final String updatedAt;
  final List<Post> posts;

  Thread.fromJson(Map<String, dynamic> parsedJson)
      : this.title = parsedJson['title'],
        this.user = User.fromJson(parsedJson['user']),
        this.updatedAt = parsedJson['updatedAt'],
        this.posts = parsedJson['posts']
                .map<Post>((json) => Post.fromJson(json))
                .toList() ??
            [];
}
