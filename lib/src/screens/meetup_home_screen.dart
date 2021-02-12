import 'package:flutter/material.dart';

class MeetupHomeScreen extends StatefulWidget {
  @override
  _MeetupHomeScreenState createState() => _MeetupHomeScreenState();
}

class _MeetupHomeScreenState extends State<MeetupHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('I am Meetup Home Screen')),
    );
  }
}
