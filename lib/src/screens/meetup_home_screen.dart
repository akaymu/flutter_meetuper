import 'package:flutter/material.dart';

import '../models/meetup.dart';
import '../services/auth_api_service.dart';
import '../services/meetup_api_service.dart';
import 'meetup_detail_screen.dart';

class MeetupDetailArguments {
  final String id;
  MeetupDetailArguments({this.id});
}

class MeetupHomeScreen extends StatefulWidget {
  // Navigation route name
  static const String route = '/meetupHome';

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
  final AuthApiService authApiService = AuthApiService();

  Widget _buildUserWelcome() {
    return FutureBuilder<bool>(
      initialData: false,
      future: authApiService.isAuthenticated(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data) {
          final user = authApiService.authUser;
          return Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                // List içinde ternary operation kullanırken null kullanamazsın.
                // Bu sebeple aşağıdaki gibi süslü parantezsiz if kullanabilirsin.
                if (user.avatar != null)
                  CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
                Text('Welcome ${user.username}'),
                Spacer(), // Olabildiğince büyük yer kaplar...
                GestureDetector(
                  onTap: authApiService.logout,
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(width: 0, height: 0);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Meetups',
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildUserWelcome(),
        ],
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
              radius: 25.0,
              backgroundImage: NetworkImage(meetup.image),
            ),
            title: Text(meetup.title),
            subtitle: Text(meetup.description),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('Visit Meetup'),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    MeetupDetailScreen.route,
                    arguments: MeetupDetailArguments(id: meetup.id),
                  );
                },
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
