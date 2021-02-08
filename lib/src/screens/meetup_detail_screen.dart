import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/widgets/bottom_navigation.dart';

class MeetupDetailScreen extends StatelessWidget {
  static final String route = '/meetupDetail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meetup Detail'),
      ),
      body: Center(
        child: Text('I am Meetup Detail Screen'),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
