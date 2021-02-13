import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/models/meetup.dart';
import 'package:flutter_meetuper/src/services/meetup_api_service.dart';

import '../widgets/bottom_navigation.dart';

class MeetupDetailScreen extends StatefulWidget {
  static const String route = '/meetupDetail';

  final String meetupId;
  MeetupDetailScreen({@required this.meetupId});

  final MeetupApiService _meetupApiService = MeetupApiService();

  @override
  _MeetupDetailScreenState createState() => _MeetupDetailScreenState();
}

class _MeetupDetailScreenState extends State<MeetupDetailScreen> {
  Meetup meetup;

  @override
  void initState() {
    super.initState();
    _fetchMeetupById(widget.meetupId);
  }

  void _fetchMeetupById(String id) async {
    final Meetup meetup = await widget._meetupApiService.fetchMeetupById(id);

    setState(() {
      this.meetup = meetup;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(meetup?.id ?? '');
    print(meetup?.title ?? '');
    print(meetup?.description ?? '');
    return Scaffold(
      appBar: AppBar(
        title: Text('Meetup Detail'),
      ),
      body: Center(
        child: Text(widget.meetupId),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
