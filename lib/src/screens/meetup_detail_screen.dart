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
    setState(() => this.meetup = meetup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meetup Detail'),
      ),
      body: meetup != null
          ? Column(
              children: <Widget>[
                HeaderSection(meetup: meetup),
                TitleSection(meetup: meetup),
                AdditionalInfoSection(meetup: meetup),
              ],
            )
          : Container(width: 0, height: 0),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

class AdditionalInfoSection extends StatelessWidget {
  final Meetup meetup;
  AdditionalInfoSection({@required this.meetup});

  String _capitalize(String word) {
    if (word == null || word.isEmpty) {
      return '';
    }

    return word[0].toUpperCase() + word.substring(1);
  }

  Column _buildColumn(String label, String text, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
        Text(
          _capitalize(text),
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildColumn('CATEGORY', meetup.category.name, color),
        _buildColumn('FROM', meetup.timeFrom, color),
        _buildColumn('TO', meetup.timeTo, color),
      ],
    );
  }
}

class TitleSection extends StatelessWidget {
  final Meetup meetup;
  TitleSection({@required this.meetup});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  meetup.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  meetup.shortInfo,
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Icon(
            Icons.people,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 5.0),
          Text('${meetup.joinedPeopleCount} People'),
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final Meetup meetup;
  HeaderSection({@required this.meetup});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        Image.network(
          meetup.image,
          width: width,
          height: 240.0,
          fit: BoxFit.cover,
        ),
        Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.3),
          ),
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(
                  'https://cdn.dribbble.com/users/304574/screenshots/6222816/male-user-placeholder.png?compress=1&resize=400x300'),
            ),
            title: Text(
              meetup.title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              meetup.shortInfo,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
