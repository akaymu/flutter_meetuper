import 'package:flutter_meetuper/src/models/category.dart';

class LoginFormData {
  String email = '';
  String password = '';

  Map<String, dynamic> toJson() {
    return {'email': this.email, 'password': this.password};
  }
}

class RegisterFormData {
  String email = '';
  String username = '';
  String name = '';
  String password = '';
  String passwordConfirmation = '';
  String avatar = '';

  Map<String, dynamic> toJson() => {
        'email': email,
        'username': username,
        'name': name,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
        'avatar': avatar
      };
}

class MeetupFormData {
  String location = '';
  String title = '';
  DateTime startDate;
  Category category;
  String image = '';
  String shortInfo = '';
  String description = '';
  String timeTo = '';
  String timeFrom = '';

  Map<String, dynamic> toJson() => {
        'location': location,
        'title': title,
        'startDate': startDate.toIso8601String(),
        'category': category.toJson(),
        'image': image,
        'shortInfo': shortInfo,
        'description': description,
        'timeTo': timeTo,
        'timeFrom': timeFrom
      };
}
