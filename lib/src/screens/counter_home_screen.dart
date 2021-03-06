import 'package:flutter/material.dart';

import '../blocs/bloc_provider.dart';
import '../blocs/counter_bloc.dart';
import '../widgets/bottom_navigation.dart';
import 'meetup_detail_screen.dart';

class CounterHomeScreen extends StatefulWidget {
  static const String route = '/counter';

  final String _title;
  CounterHomeScreen({String title}) : _title = title;

  @override
  _CounterHomeScreenState createState() => _CounterHomeScreenState();
}

class _CounterHomeScreenState extends State<CounterHomeScreen> {
  CounterBloc counterBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    counterBloc = BlocProvider.of<CounterBloc>(context);
  }

  _increment() {
    // call stream
    counterBloc.increment(15);
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
              stream: counterBloc.counterStream,
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
                stream: counterBloc.counterStream,
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
