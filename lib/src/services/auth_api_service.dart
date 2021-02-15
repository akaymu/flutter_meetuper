import 'dart:convert';
import 'package:flutter_meetuper/src/models/forms.dart';
import 'package:http/http.dart' as http;
import '../models/meetup.dart';
import 'dart:io' show Platform;

class AuthApiService {
  final String url = Platform.isIOS
      ? 'http://localhost:3001/api/v1'
      : 'http://10.0.2.2:3001/api/v1';

  // Private Constructor
  AuthApiService._();

  // Static singleton and factory constructor
  static final AuthApiService _singleton = AuthApiService._();
  factory AuthApiService() => _singleton;

  Future<Map<String, dynamic>> login(LoginFormData loginData) async {
    final body = json.encode(loginData.toJson());
    final res = await http.post(
      '$url/users/login',
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    final parsedData = Map<String, dynamic>.from(json.decode(res.body));

    if (res.statusCode == 200) {
      return parsedData;
    } else {
      return Future.error(parsedData);
    }
  }
}
