import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/blocs/meetup_bloc.dart';
import 'package:flutter_meetuper/src/models/thread.dart';

class ThreadList extends StatelessWidget {
  final MeetupBloc bloc;
  ThreadList({@required this.bloc}) : assert(bloc != null);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Thread>>(
      stream: bloc.threads,
      builder: (BuildContext context, AsyncSnapshot<List<Thread>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(snapshot.data[index].title);
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
