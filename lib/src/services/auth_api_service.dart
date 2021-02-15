import 'dart:convert';
import 'dart:io' show Platform;

import 'package:http/http.dart' as http;

import '../models/forms.dart';
import '../models/user.dart';

class AuthApiService {
  final String url = Platform.isIOS
      ? 'http://localhost:3001/api/v1'
      : 'http://10.0.2.2:3001/api/v1';

  String _token;
  User _authUser;

  // Private Constructor
  AuthApiService._();

  // Static singleton and factory constructor
  static final AuthApiService _singleton = AuthApiService._();
  factory AuthApiService() => _singleton;

  // Getters and Setters
  set authUser(Map<String, dynamic> value) {
    _authUser = User.fromJson(value);
  }

  bool _saveToken(String token) {
    if (token != null) {
      _token = token;
      return true;
    }

    return false;
  }

  Future<Map<String, dynamic>> login(LoginFormData loginData) async {
    final body = json.encode(loginData.toJson());
    final res = await http.post(
      '$url/users/login',
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    final parsedData = Map<String, dynamic>.from(json.decode(res.body));

    if (res.statusCode == 200) {
      _saveToken(parsedData['token']);
      authUser = parsedData; // Setting _authUser with setter function
      print(_authUser);
      print(_authUser.name);
      print(_authUser.username);
      print(_authUser.email);
      return parsedData;
    } else {
      return Future.error(parsedData);
    }
  }
}
