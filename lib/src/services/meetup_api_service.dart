import 'dart:convert';
import 'dart:io' show Platform;

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/category.dart';
import '../models/forms.dart';
import '../models/meetup.dart';
import '../models/thread.dart';

class MeetupApiService {
  final String url = Platform.isIOS
      ? 'http://localhost:3001/api/v1'
      : 'http://10.0.2.2:3001/api/v1';

  // Private Constructor
  MeetupApiService._();

  // Static singleton and factory constructor
  static final MeetupApiService _singleton = MeetupApiService._();
  factory MeetupApiService() => _singleton;

  // Fetch Meetups
  Future<List<Meetup>> fetchMeetups() async {
    final res = await http.get('$url/meetups');

    final List parsedMeetups = json.decode(res.body);
    return parsedMeetups.map((val) => Meetup.fromJson(val)).toList();
  }

  // Fetch a single Meetup by id
  Future<Meetup> fetchMeetupById(String id) async {
    final res = await http.get('$url/meetups/$id');

    final Map<String, dynamic> parsedMeetup = json.decode(res.body);
    return Meetup.fromJson(parsedMeetup);
  }

  Future<List<Category>> fetchCategories() async {
    final res = await http.get('$url/categories');
    final List decodedBody = json.decode(res.body);
    return decodedBody.map((val) => Category.fromJson(val)).toList();
  }

  Future<String> createMeetup(MeetupFormData formData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String body = json.encode(formData.toJson());

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final res = await http.post('$url/meetups', headers: headers, body: body);

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return Future.error(res.body);
    }
  }

  Future<List<Thread>> fetchThreads(String meetupId) async {
    final res = await http.get('$url/threads?meetupId=$meetupId');
    final Map<String, dynamic> parsedBody = json.decode(res.body);
    List<dynamic> parsedThreads = parsedBody['threads'];
    return parsedThreads.map((val) => Thread.fromJson(val)).toList();
  }

  // Join Meetup
  Future<bool> joinMeetup(String meetupId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      await http.post(
        '$url/meetups/$meetupId/join',
        headers: {'Authorization': 'Bearer $token'},
      );

      return true;
    } catch (e) {
      throw Exception('Cannot join meetup');
    }
  }

  // Leave Meetup
  Future<bool> leaveMeetup(String meetupId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      await http.post(
        '$url/meetups/$meetupId/leave',
        headers: {'Authorization': 'Bearer $token'},
      );

      return true;
    } catch (e) {
      throw Exception('Cannot leave meetup');
    }
  }
}
