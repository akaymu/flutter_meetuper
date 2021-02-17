import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meetup.dart';
import 'dart:io' show Platform;

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
