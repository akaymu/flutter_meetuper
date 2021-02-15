class User {
  final String id;
  final String name;
  final String username;
  final String email;
  String avatar;
  String info;
  List<String> joinedMeetups = [];

  User.fromJson(Map<String, dynamic> parsedJson)
      : this.id = parsedJson['_id'],
        this.name = parsedJson['name'],
        this.username = parsedJson['username'],
        this.email = parsedJson['email'],
        this.avatar = parsedJson['avatar'] ?? '',
        this.info = parsedJson['info'] ?? '',
        this.joinedMeetups = parsedJson['joinedMeetups']?.cast<String>() ?? [];
}
