import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/blocs/meetup_bloc.dart';
import 'package:flutter_meetuper/src/models/meetup.dart';

class JoinedPeopleList extends StatelessWidget {
  final MeetupBloc bloc;
  JoinedPeopleList({@required this.bloc}) : assert(bloc != null);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Meetup>(
      stream: bloc.meetupDetail,
      builder: (BuildContext context, AsyncSnapshot<Meetup> snapshot) {
        if (snapshot.hasData) {
          final users = snapshot.data.joinedPeople;
          if (users != null && users.length > 0) {
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final user = users[index];
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage: user.avatar.isNotEmpty
                              ? NetworkImage(user?.avatar)
                              : null,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }
        return Container(width: 0, height: 0);
      },
    );
  }
}
