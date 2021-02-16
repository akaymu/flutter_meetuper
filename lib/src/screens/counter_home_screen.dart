import 'package:flutter/material.dart';
import 'package:flutter_meetuper/src/blocs/counter_bloc.dart';

import '../widgets/bottom_navigation.dart';
import 'meetup_detail_screen.dart';

class CounterHomeScreen extends StatefulWidget {
  static const String route = '/counter';

  final String _title;
  CounterBloc bloc;
  CounterHomeScreen({String title, this.bloc}) : _title = title;

  @override
  _CounterHomeScreenState createState() => _CounterHomeScreenState();
}

class _CounterHomeScreenState extends State<CounterHomeScreen> {
  // CounterBloc counterBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // counterBloc = CounterBlocProvider.of(context);
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  _increment() {
    // call stream
    widget.bloc.increment(15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome in ${widget._title}, lets increment numbers!',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 15.0),
            ),
            StreamBuilder<int>(
              stream: widget.bloc.counterStream,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'Click Counter: ${snapshot.data}',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 30.0),
                  );
                } else {
                  return Text(
                    'Counter is sad, no data!',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 30.0),
                  );
                }
              },
            ),
            RaisedButton(
              child: StreamBuilder<int>(
                stream: widget.bloc.counterStream,
                initialData: 0,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    return Text('Counter - ${snapshot.data}');
                  } else {
                    return Text('Counter is sad!');
                  }
                },
              ),
              onPressed: () {
                Navigator.pushNamed(context, MeetupDetailScreen.route);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Increment',
        onPressed: _increment,
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
