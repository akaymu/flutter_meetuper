import 'dart:convert';
import 'package:http/http.dart' as http;
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
}
