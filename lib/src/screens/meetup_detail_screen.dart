import 'package:flutter/material.dart';

import '../blocs/bloc_provider.dart';
import '../blocs/meetup_bloc.dart';
import '../blocs/user_bloc/user_bloc.dart';
import '../models/meetup.dart';
import '../services/auth_api_service.dart';
import '../widgets/bottom_navigation.dart';

class MeetupDetailScreen extends StatefulWidget {
  static const String route = '/meetupDetail';

  final String meetupId;
  MeetupDetailScreen({@required this.meetupId});

  @override
  _MeetupDetailScreenState createState() => _MeetupDetailScreenState();
}

class _MeetupDetailScreenState extends State<MeetupDetailScreen> {
  MeetupBloc _meetupBloc;
  UserBloc _userBloc;
  Meetup _meetup;

  @override
  void initState() {
    _meetupBloc = BlocProvider.of<MeetupBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);

    _meetupBloc.fetchMeetupDetail(widget.meetupId);
    _meetupBloc.meetupDetail.listen((meetup) {
      _meetup = meetup;
      _userBloc.dispatch(CheckUserPermissionsOnMeetup(meetup: meetup));
    });
    super.initState();
  }

  _joinMeetup() {
    // _userBloc.dispatch(JoinMeetup());
    _meetupBloc.joinMeetup(_meetup);
  }

  _leaveMeetup() {
    // _userBloc.dispatch(LeaveMeetup());
    _meetupBloc.leaveMeetup(_meetup);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserState>(
      stream: _userBloc.userState,
      initialData: UserInitialState(),
      builder: (BuildContext context, AsyncSnapshot<UserState> snapshot) {
        final userState = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text('Meetup Detail'),
          ),
          body: StreamBuilder<Meetup>(
            stream: _meetupBloc.meetupDetail,
            builder: (BuildContext context, AsyncSnapshot<Meetup> snapshot) {
              if (snapshot.hasData) {
                final meetup = snapshot.data;
                return ListView(
                  children: <Widget>[
                    HeaderSection(meetup),
                    TitleSection(meetup),
                    AdditionalInfoSection(meetup),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
                            'Alps. Situated 1,578 meters above sea level, it is one of the '
                            'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
                            'half-hour walk through pastures and pine forest, leads you to the '
                            'lake, which warms to 20 degrees Celsius in the summer. Activities '
                            'enjoyed here include rowing, and riding the summer toboggan run.'),
                      ),
                    ),
                  ],
                );
              }
              return Container(width: 0, height: 0);
            },
          ),
          bottomNavigationBar: BottomNavigation(),
          floatingActionButton: _MeetupActionButton(
            userState: userState,
            joinMeetup: _joinMeetup,
            leaveMeetup: _leaveMeetup,
          ),
        );
      },
    );
  }
}

class _MeetupActionButton extends StatelessWidget {
  final AuthApiService auth = AuthApiService();

  final UserState userState;
  final Function joinMeetup;
  final Function leaveMeetup;

  _MeetupActionButton({
    @required this.userState,
    @required this.joinMeetup,
    @required this.leaveMeetup,
  });

  @override
  Widget build(BuildContext context) {
    if (userState is UserIsMember) {
      return FloatingActionButton(
        onPressed: leaveMeetup,
        child: Icon(Icons.person_remove),
        backgroundColor: Colors.red,
        tooltip: 'Leave Meetup',
      );
    } else if (userState is UserIsNotMember) {
      return FloatingActionButton(
        onPressed: joinMeetup,
        child: Icon(Icons.person_add),
        backgroundColor: Colors.green,
        tooltip: 'Join Meetup',
      );
    } else {
      return Container(width: 0.0, height: 0.0);
    }
  }
}

class AdditionalInfoSection extends StatelessWidget {
  final Meetup meetup;
  AdditionalInfoSection(this.meetup);

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
  TitleSection(this.meetup);

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
  HeaderSection(this.meetup);

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
