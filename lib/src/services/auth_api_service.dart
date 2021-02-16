import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter_meetuper/src/utils/jwt.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/forms.dart';
import '../models/user.dart';

class AuthApiService {
  final String url = Platform.isIOS
      ? 'http://localhost:3001/api/v1'
      : 'http://10.0.2.2:3001/api/v1';

  String _token = '';
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

  get authUser => _authUser;

  Future<String> get token async {
    if (_token.isNotEmpty) {
      return _token;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    }
  }

  Future<bool> _persistToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', token);
  }

  Future<bool> _saveToken(String token) async {
    if (token != null) {
      await _persistToken(token);
      _token = token;
      return true;
    }

    return false;
  }

  Future<bool> isAuthenticated() async {
    final token = await this.token;
    if (token.isNotEmpty) {
      final decodedToken = decode(token);

      if (decodedToken['exp'] * 1000 > DateTime.now().millisecond) {
        authUser = decodedToken; // Setting _authUser with setter function
        return true;
      }
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
      return parsedData;
    } else {
      return Future.error(parsedData);
    }
  }

  Future<void> _removeAuthData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = '';
    _authUser = null;
  }

  Future<bool> logout() async {
    try {
      await _removeAuthData();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
