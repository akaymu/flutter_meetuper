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
    final body = json.encode(loginData);
    final res = await http.post('$url/users/login', body: body);

    final parsedData = json.decode(res.body);
    return parsedData;
  }
}
