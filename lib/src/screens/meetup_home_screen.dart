import 'package:flutter/material.dart';

import 'package:flutter_meetuper/src/models/meetup.dart';
import 'package:flutter_meetuper/src/services/meetup_api_service.dart';

class MeetupHomeScreen extends StatefulWidget {
  final MeetupApiService _meetupApiService = MeetupApiService();

  @override
  _MeetupHomeScreenState createState() => _MeetupHomeScreenState();
}

class _MeetupHomeScreenState extends State<MeetupHomeScreen> {
  List<Meetup> meetups = [];

  @override
  void initState() {
    super.initState();
    _fetchMeetups();
  }

  void _fetchMeetups() async {
    final List<Meetup> meetupList =
        await widget._meetupApiService.fetchMeetups();

    setState(() => this.meetups = meetupList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        children: <Widget>[
          _MeetupTitle(),
          _MeetupList(meetups: meetups),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _MeetupTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(20.0),
      child: Text(
        'Featured Meetup',
        style: const TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _MeetupCard extends StatelessWidget {
  final Meetup meetup;
  _MeetupCard({@required this.meetup});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(meetup.image),
            ),
            title: Text(meetup.title),
            subtitle: Text(meetup.description),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('Visit Meetup'),
                onPressed: () {},
              ),
              FlatButton(
                onPressed: () {},
                child: Text('Favorite'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MeetupList extends StatelessWidget {
  final List<Meetup> meetups;

  _MeetupList({@required this.meetups});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: meetups.length * 2,
        itemBuilder: (BuildContext context, int i) {
          if (i.isOdd) {
            return Divider();
          }
          final int index = i ~/ 2;

          return _MeetupCard(meetup: meetups[index]);
        },
      ),
    );
  }
}
