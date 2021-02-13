import 'package:flutter/material.dart';

import '../widgets/bottom_navigation.dart';

class MeetupDetailScreen extends StatelessWidget {
  static const String route = '/meetupDetail';

  final String meetupId;
  MeetupDetailScreen({@required this.meetupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meetup Detail'),
      ),
      body: Center(
        child: Text(meetupId),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
